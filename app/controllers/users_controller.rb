class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  #include AuthenticatedSystem

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = _ "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])

    unless user_required?(@user)
      permission_denied
      return
    end
  end

  def update
    @user = User.find(params[:id])
    unless user_required?(@user)
      permission_denied
      return
    end
    if @user.update_attributes(params[:user])
      redirect_to(profile_url(@user.profile))
    else
      render :action => "edit"
    end
  end
  
end
