class ProfilesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found

  # GET /profiles
  # GET /profiles.xml
  def index
    # @profiles = Profile.find(:all)
    @per_page = 20
    @current_page = (params[:page].nil? ? 1 : params[:page])
    @profiles = Profile.paginate_find_sorted(@per_page, @current_page)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profiles }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.xml
  def show
    @profile = Profile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
  end


  # GET /profiles/1/edit
  def edit
    @profile = Profile.find(params[:id])

    user_required?(@profile.user) or permission_denied
  end

  # PUT /profiles/1
  # PUT /profiles/1.xml
  def update
    @profile = Profile.find(params[:id])

    unless user_required?(@profile.user)
      permission_denied
      return
    end

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        flash[:notice] = _ 'Profile was successfully updated.'
        #format.html { redirect_to(@profile) }
        #format.html  { redirect_to(profiles_path)}
        format.html  { redirect_to("/") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.xml
  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    unless user_required?(@profile.user)
      permission_denied
      return
    end

    respond_to do |format|
      format.html { redirect_to(profiles_url) }
      format.xml  { head :ok }
    end
  end
end
