class RoleListsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
  before_filter :admin_permissions_required

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attribute :role_ids, params[:user][:role_ids]
        flash[:notice] = 'Role list was successfully updated.'
        format.html { redirect_to(profiles_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end
