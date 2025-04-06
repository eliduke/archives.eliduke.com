class PostsController < ApplicationController
  def index
    @posts = Post.order(created: :desc).limit(100)
  end
end
