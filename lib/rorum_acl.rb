module RorumAcl
  OPERATIONS={ "new" => :create, "create" => :create, "edit" => :update, "update" => :update, "delete" => :delete }
  RESOURCES={ "topics" => :topic, "posts" => :post }

  protected
  def right_required?(action_name)
    operation = OPERATIONS[action_name]
    return ["index", "show"].include?(action_name) if operation.nil?
    return yield(operation) if block_given?
    false
  end

  def find_role_admin()
    return nil unless logged_in?
    current_user.roles.find :first, :conditions => ["is_admin = ?", true]
  end

  def admin?()
    !find_role_admin.nil?
  end

  def find_roles(controller_name, forum)
    if RESOURCES.include? controller_name
      current_user.roles.find :all, :include => "accesses", :conditions => ["accesses.forum_id = ? OR roles.is_admin = ?", forum, true]
    else
      current_user.roles
    end
  end

  def role_required?(controller_name, action_name, forum, object)
    # jesli nie jestesmy w kategoriach lub forach i nie czytamy
    unless ["categories", "forums"].include?(controller_name) and ["index", "show"].include?(action_name)
      # jesli uzytkownik nie jest zalogowany to uzyj praw domyslnych
      return right_required?(action_name) unless logged_in?
      # znajdz role uzyktownika ktora pozwala wykonac akcje
      !find_roles(controller_name, forum).detect do |role|
        unless role.is_admin
          if RESOURCES.include? controller_name
            # podaj flage wlasnosci i zasub
            is_owner = (object.nil? ? true : object.author == current_user)
            resource = RESOURCES[controller_name]
            # czy rola ma prawa do wykonania akcji na zasobie
            right_required?(action_name) { |operation| role.right_to? is_owner, resource, operation }
          else
            false
          end
        else
          true
        end
      end.nil? or right_required?(action_name)
    else
      true
    end
  end

  def user_required?(user)
    current_user == user if logged_in?
  end

  def permission_to?(controller_name, action_name, object = nil)
    # forum
    unless object.nil?
      forum = (object.methods.include? "forum") ? object.forum : object.topic.forum
    else
      forum = @forum
    end
    # czy istenieje rola
    role_required?(controller_name, action_name, forum, object)
  end

  def permission_required()
    # okresl obiekt
    case self.controller_name
    when "topics"
      object = @topic
    when "posts"
      object = @post
    else
      object = nil
    end
    # czy istenieje rola
    role_required?(self.controller_name, self.action_name, @forum, object) or permission_denied
  end

  def admin_permissions_required()
    admin? or permission_denied
  end

  def permission_denied()
    redirect_to("/")
    flash[:error] = _ "Permission denied"
  end

  def self.included(base)
    base.helper_method :admin?, :permission_to?, :user_required?
  end

end
