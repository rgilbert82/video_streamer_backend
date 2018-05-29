class Api::VideosController < Api::BaseController
  before_action :get_service

  def index
    yt_channel = fetch_channel_data_from_youtube
    videos     = collect_videos(yt_channel.items)

    render json: videos
  end

  def show
    video = fetch_video_from_db(params[:id])
    chat  = video.chats.first

    render json: { video: video, chat: chat }
  end

  def stats
    video = Video.find(params[:id])
    stats = {
      video_age:         video.video_age,
      stream_age:        video.stream_age,
      total_comments:    video.total_comments,
      comments_per_hour: video.comments_per_hour
    }

    render json: stats
  end

  private

  def fetch_channel_data_from_youtube
    @service.list_searches(
      'snippet',
      channel_id:  ENV['CHANNEL_ID'],
      event_type:  'live',
      max_results: '10',
      type:        'video'
    )
  end

  def fetch_video_data_from_youtube(video_id)
    @service.list_videos(
      'snippet,contentDetails,statistics,liveStreamingDetails',
      { id: video_id }
    ).items[0]
  end

  def collect_videos(yt_videos)
    yt_videos.map do |v|
      {
        content:      fetch_video_from_db(v.id.video_id),
        chat_enabled: !Chat.where(video_id: v.id.video_id).empty?
      }
    end
  end

  def fetch_video_from_db(video_id)
    records = Video.where(id: video_id)

    if records.empty?
      create_video_and_chat_records(video_id)
    else
      records[0]
    end
  end

  def create_video_and_chat_records(video_id)
    video     = fetch_video_data_from_youtube(video_id)
    chat_id   = video.live_streaming_details.active_live_chat_id

    new_video = create_video_record(video)
    create_chat_record(chat_id, video_id) if chat_id

    new_video
  end

  def create_video_record(video)
    Video.create(
      id:           video.id,
      channel_id:   video.snippet.channel_id,
      title:        video.snippet.title,
      thumbnail:    video.snippet.thumbnails.high.url,
      description:  video.snippet.description,
      published_at: video.snippet.published_at
    )
  end

  def create_chat_record(chat_id, video_id)
    Chat.create(
      id:       chat_id,
      video_id: video_id
    )
  end
end
