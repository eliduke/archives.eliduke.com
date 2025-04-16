class PostsController < ApplicationController
  def index
    @posts = Post.order(created: :desc).limit(100)
    @posts = Post.where("title LIKE ?", "%#{params[:q]}%") if params[:q]
  end

  def show
    @post     = Post.find(params[:id])
    @elements = if @post.elements.any?
      # include the post as the first element
      @post.elements.to_a.unshift(@post)
    else
      # include only the post, so the
      # .each in the view still works
      [ @post ]
    end
  end
end
