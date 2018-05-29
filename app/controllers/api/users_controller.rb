class Api::UsersController < Api::BaseController
  def show
    user     = User.find(params[:id])
    comments = user.comments.sort_by(&:created_at).map do |comment|
      {
        comment: comment,
        video:   comment.chat.video
      }
    end

    render json: { user: user, comments: comments }
  end
end
