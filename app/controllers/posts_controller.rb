class PostsController < ApplicationController
  before_action :set_bulletin
  before_action :set_post, only: [:show, :edit, :update, :destroy]
 
  before_action :authenticate_user!, except: [ :index, :show ]
 
  def index
    @posts = @bulletin.posts.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @post = @bulletin.posts.new
  end

  def edit
     authorize_action_for @post
  end

  def create
    @post = @bulletin.posts.new(post_params)
   # @post.user = current_user
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to [@post.bulletin, @post], notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
     authorize_action_for @post
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to [@post.bulletin, @post], notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
     authorize_action_for @post
    @post.destroy
    respond_to do |format|
      format.html { redirect_to bulletin_posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_bulletin
      @bulletin = Bulletin.find(params[:bulletin_id])
    end

    def set_post
      @post = @bulletin.posts.find(params[:id])
    end

    def post_params
       params.require(:post).permit(:title, :content, :picture, :picture_cache, :shortexplain)
    end
end
