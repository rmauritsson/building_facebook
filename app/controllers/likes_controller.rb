# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    current_user.like post if post
    redirect_back(fallback_location: root_path)
  end

  def destroy
    post = Post.find(params[:id])
    current_user.unlike post if post
    redirect_back(fallback_location: root_path)
  end
end
