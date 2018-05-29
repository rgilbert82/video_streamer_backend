class Api::CommentsController < Api::BaseController
  before_action :get_service

  def create
    message_text = params['message']
    live_chat_id = params['chat_id']
    access_token = request.env['HTTP_AUTHORIZATION']

    auth = Signet::OAuth2::Client.new
    auth.access_token = access_token
    auth.expires_in   = 3000

    @service.authorization = auth

    message = Google::Apis::YoutubeV3::LiveChatMessage.new
    snippet = Google::Apis::YoutubeV3::LiveChatMessageSnippet.new
    message.snippet = snippet

    snippet.type                 = 'textMessageEvent'
    snippet.live_chat_id         = live_chat_id
    snippet.text_message_details = { message_text: message_text }

    comment = @service.insert_live_chat_message('snippet', message)

    render json: comment
  end

  def chat_index
    yt_data         = fetch_comments_data_from_youtube
    new_comments    = collect_new_comments(yt_data.items)

    Chat.find(params[:id]).update_column(:page_token, yt_data.next_page_token)

    # return 30 for initial comment load, else just load new comments
    new_comments = fetch_initial_comments_load unless params[:updating_list]

    render json: {
      comments:      comments_with_user(new_comments),
      poll_interval: yt_data.polling_interval_millis || 3000
    }
  end

  private

  def fetch_comments_data_from_youtube
    @service.list_live_chat_messages(
      params[:id],
      'snippet,authorDetails',
      page_token: params[:pageToken]
    )
  end

  def comments_with_user(comments)
    comments.map do |comment|
      { comment: comment, user: comment.user }
    end
  end

  def fetch_initial_comments_load
    Comment.where(chat_id: params[:id])
           .limit(30).order('created_at desc').reverse
  end

  def collect_new_comments(yt_comments)
    comments = yt_comments.map do |c|
      fetch_new_comment_from_db(c)
    end

    comments.reject(&:nil?)
  end

  def fetch_new_comment_from_db(comment)
    comment_id = comment.id.gsub(/[^A-Za-z0-9]/, '')
    records    = Comment.where(id: comment_id)

    return nil unless records.empty? && comment.author_details

    create_user_and_comment_records(comment)
  end

  def create_user_and_comment_records(comment)
    # first create a user record if the comment author is not in the DB yet
    user_records = User.where(id: comment.author_details.channel_id)
    create_user_record(comment.author_details) if user_records.empty?

    # then create and return the comment
    create_comment_record(comment)
  end

  def create_user_record(user)
    User.create(
      id:          user.channel_id,
      username:    user.display_name,
      image_url:   user.profile_image_url,
      youtube_url: user.channel_url
    )
  end

  def create_comment_record(comment)
    Comment.create(
      id:           comment.id.gsub(/[^A-Za-z0-9]/, ''),
      chat_id:      params[:id],
      user_id:      comment.author_details.channel_id,
      message:      comment.snippet.display_message,
      published_at: comment.snippet.published_at
    )
  end
end
