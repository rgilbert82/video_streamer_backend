class Api::UsersController < Api::BaseController
  def show
    user     = User.find(params[:id])
    comments = Comment.where(user_id: params[:id]).map do |comment|
      {
        comment: comment,
        video:   comment.chat.video
      }
    end

    render json: { user: user, comments: comments }
  end
end
