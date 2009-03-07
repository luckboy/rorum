class TopicsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  before_filter :load_forum_if_no_search
  before_filter :forum_required
  before_filter :permission_required

  # GET /topics
  # GET /topics.xml
  def index
    # @topics = Topic.find(:all)
    @per_page = 10
    @current_page = (params[:page].nil? ? 1 : params[:page])
    unless searching?
      @topics = @forum.paginate_topics_sorted @per_page, @current_page
    else
      @topics = Topic.paginate_search_topics @per_page, @current_page, params
      unless @topics
        redirect_to(search_url)
        flash[:error] = "You have to enter keywords and/or author to search for."
        return
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @topics }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    # @topic = Topic.find(params[:id])
    @topic = @forum.topics.find(params[:id])
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new(params[:topic])
    @topic.author = current_user
    @forum.topics << @topic

    respond_to do |format|
      if @topic.save
        flash[:notice] = _ 'Topic was successfully created.'
        #format.html { redirect_to([@forum, @topic]) }
        format.html { redirect_to([@topic, "posts"]) }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    # @topic = Topic.find(params[:id])
    @topic = @forum.topics.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        flash[:notice] = _ 'Topic was successfully updated.'
        #format.html { redirect_to([@forum, @topic]) }
        format.html { redirect_to([@topic, "posts"]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    # @topic = Topic.find(params[:id])
    @topic = @forum.topics.find(params[:id])
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to(forum_topics_url) }
      format.xml  { head :ok }
    end
  end

  protected
  def load_forum_if_no_search
    load_forum unless params[:forum_id].nil?
  end

  def forum_required
    render_not_found if searching? and action_name != "index"
  end

  def searching?
    @forum.nil?
  end

  helper_method :searching?

end
