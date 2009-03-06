class PostsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  before_filter :load_topic_and_forum
  before_filter :permission_required

  # GET /posts
  # GET /posts.xml
  def index
    # @posts = Post.find(:all)
    load_posts
    @post = Post.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    # @post = Post.find(params[:id])
    @post = @topic.posts.find(params[:id])

    #respond_to do |format|
    #  format.html # show.html.erb
    #  format.xml  { render :xml => @post }
    #end

    respond_to do |format|
      format.html { redirect_to(topic_posts_url(:page => (@topic.page_with_post @per_page, @post), :anchor => "post_#{@post.id}")) }
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    @post.author = current_user
    @topic.posts << @post

    respond_to do |format|
      if @post.save
        flash[:notice] = _ 'Post was successfully created.'
        # format.html { redirect_to([@topic, @post]) }
        format.html { redirect_to(topic_posts_url) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        # format.html { render :action => "new" }
        load_posts
        format.html { render :action => "index" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    # @post = Post.find(params[:id])
    @posts = @topic.posts.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = _ 'Post was successfully updated.'
        #format.html { redirect_to([@topic, @post]) }
        format.html { redirect_to(topic_posts_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    # @post = Post.find(params[:id])
    @post = @topic.posts.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(topic_posts_url) }
      format.xml  { head :ok }
    end
  end

  protected
  def load_topic_and_forum
    load_topic
    @forum = @topic.forum
  end

  def load_posts
    @per_page = 10
    @current_page = (params[:page].nil? ? 1 : params[:page])
    @posts = @topic.paginate_posts_sorted @per_page, @current_page
  end
end
