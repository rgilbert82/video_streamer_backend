class Api::VideosController < Api::BaseController
  before_action :get_service

  def index
    yt_channel = fetch_channel_data_from_youtube
    videos     = collect_videos(yt_channel.items)

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
      video_age:         video.get_video_age,
      stream_age:        video.get_stream_age,
      total_comments:    video.get_total_comments,
      comments_per_hour: video.get_comments_per_hour
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
    video     = fetch_video_data_from_youtube(video_id)
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
end
