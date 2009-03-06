class RolesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  before_filter :admin_permissions_required

  # GET /roles
  # GET /roles.xml
  def index
    @roles = Role.find :all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roles }
    end
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    @role = Role.new
    @forums = Forum.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
    @forums = Forum.find(:all)
  end

  # POST /roles
  # POST /roles.xml
  def create
    @role = Role.new(params[:role])

    respond_to do |format|
      if @role.save
        flash[:notice] = _ 'Role was successfully created.'
        # format.html { redirect_to(@role) }
        format.html { redirect_to(roles_url)}
        format.xml  { render :xml => @role, :status => :created, :location => @role }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    @role = Role.find(params[:id])

    respond_to do |format|
      if @role.update_attributes(params[:role])
        flash[:notice] = _ 'Role was successfully updated.'
        # format.html { redirect_to(@role) }
        format.html { redirect_to(roles_url)}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    respond_to do |format|
      format.html { redirect_to(roles_url) }
      format.xml  { head :ok }
    end
  end
end
