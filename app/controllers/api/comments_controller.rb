class Api::CommentsController < Api::BaseController
  before_action :get_service

  def show
    yt_comments     = fetch_comments_from_youtube
    new_comments    = collect_new_comments(yt_comments.items)
    next_page_token = yt_comments.next_page_token
    poll_interval   = yt_comments.polling_interval_millis || 3000

    Chat.find(params[:id]).update_column(:page_token, next_page_token)

    if params[:updating_list]      # return new comments since last update only
      render json: {
        poll_interval: poll_interval,
        comments: comments_with_user(new_comments)
      }
    else                           # return the 30 most recent comments
      comments = Comment.where(chat_id: params[:id]).limit(30).order('created_at desc').reverse
      render json: {
        poll_interval: poll_interval,
        comments: comments_with_user(comments)
      }
    end
  end

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

  private

  def fetch_comments_from_youtube
    @service.list_live_chat_messages(
      params[:id],
      'snippet,authorDetails',
      page_token: params[:pageToken]
    )
  end

  def collect_new_comments(yt_comments)
    yt_comments.map do |c|
      fetch_new_comment_from_db(c)
    end.reject {|c| c.nil? }
  end

  def fetch_new_comment_from_db(comment)
    comment_id = comment.id.gsub(/[^A-Za-z0-9]/, '')
    records    = Comment.where(id: comment_id)

    if records.empty?
      create_comment_record(comment)
    end
  end

  def comments_with_user(comments)
    comments.map do |comment|
      { comment: comment, user: comment.user }
    end
  end

  def create_comment_record(comment)
    # first create a user record if the comment author is not in the DB yet
    user_records = User.where(id: comment.author_details.channel_id)
    create_user_record(comment.author_details) if user_records.empty?

    # then create the comment
    comment_id  = comment.id.gsub(/[^A-Za-z0-9]/, '')
    new_comment = Comment.create(
      id:           comment_id,
      chat_id:      params[:id],
      user_id:      comment.author_details.channel_id,
      message:      comment.snippet.display_message,
      published_at: comment.snippet.published_at
    )

    new_comment
  end

  def create_user_record(user)
    User.create(
      id:          user.channel_id,
      username:    user.display_name,
      image_url:   user.profile_image_url,
      youtube_url: user.channel_url
    )
  end
end
