class CommentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    post = Post.find(params[:comment][:post_id])
    post&.comments&.create(content: params[:comment][:content],user_id: current_user.id)
    redirect_back(fallback_location: root_path)
  end
end
