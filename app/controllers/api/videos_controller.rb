class Api::VideosController < Api::BaseController
  before_action :get_service

  def index
    yt_videos = fetch_videos_from_youtube
    videos    = collect_videos(yt_videos.items)

    render json: videos
  end

  def show
    video = fetch_video_from_db(params[:id])
    chat  = Chat.where(video_id: params[:id])[0]

    render json: { video: video, chat: chat }
  end

  def stats
    video = Video.find(params[:id])
    stats = {
      video_age:         get_video_age(video),
      stream_age:        get_stream_age(video),
      total_comments:    get_total_comments(video),
      comments_per_hour: get_comments_per_hour(video)
    }

    render json: stats
  end

  private

  def fetch_videos_from_youtube
    @service.list_searches(
      'snippet',
      channel_id:  ENV['CHANNEL_ID'],
      event_type:  'live',
      max_results: '10',
      type:        'video'
    )
  end

  def fetch_video_from_youtube(video_id)
    @service.list_videos(
      'snippet,contentDetails,statistics,liveStreamingDetails',
      { id: video_id }
    ).items[0]
  end

  def collect_videos(yt_videos)
    yt_videos.map do |v|
      {
        content:      fetch_video_from_db(v.id.video_id),
        chat_enabled: Chat.where(video_id: v.id.video_id).length > 0
      }
    end
  end

  def fetch_video_from_db(video_id)
    records = Video.where(id: video_id)

    if records.empty?
      create_video_record(video_id)
    else
      records[0]
    end
  end

  def create_video_record(video_id)
    video     = fetch_video_from_youtube(video_id)
    chat_id   = video.live_streaming_details.active_live_chat_id

    new_video = Video.create(
      id:           video.id,
      channel_id:   video.snippet.channel_id,
      title:        video.snippet.title,
      thumbnail:    video.snippet.thumbnails.high.url,
      description:  video.snippet.description,
      published_at: video.snippet.published_at
    )

    if chat_id
      Chat.create(
        id:       chat_id,
        video_id: video_id
      )
    end

    new_video
  end

  # Video stats methods

  def get_video_age(video)
    video_time = Time.parse(video.published_at)
    ((Time.now - video_time) / 3600).round
  end

  def get_stream_age(video)
    if get_total_comments(video) > 0
      comment = video.chats.first.comments.order('created_at').first
      first   = Time.parse(comment.published_at)
      ((Time.now - first) / 3600).round
    else
      ((Time.now - video.created_at) / 3600).round
    end
  end

  def get_total_comments(video)
    chat = video.chats.first
    if chat
      chat.comments.count
    else
      0
    end
  end

  def get_comments_per_hour(video)
    chat  = video.chats.first
    total = get_total_comments(video)

    if total > 0
      comments = chat.comments.order('created_at')
      earliest = Time.parse(comments.first.published_at)
      latest   = Time.parse(comments.last.published_at)
      hours    = (latest - earliest) / 3600
      (total / hours).round(2)
    else
      0
    end
  end
end
