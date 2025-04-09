class PostsController < ApplicationController
  def index
    @posts = Post.order(created: :desc).limit(100)
    @posts = Post.where("title LIKE ?", "%#{params[:q]}%") if params[:q]
  end

  def show
    @post = Post.find(params[:id])
  end
end
