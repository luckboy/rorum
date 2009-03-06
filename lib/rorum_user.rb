# To change this template, choose Tools | Templates
# and open the template in the editor.

module RorumUser
  protected

  def create_new_profile
    unless self.profile
      self.create_profile
    end
  end

  def add_default_roles
    if self.roles.empty?
      default_roles = Role.find :all, :conditions => ['is_default = ?', true]
      default_roles.each { |role| self.roles << role }
    end
  end

  public
  def role_ids
    self.roles.collect { |role| role.id}
  end

  def role_ids=(role_ids)
    self.roles = role_ids.connect { |role_id| Role.find(role_id) }
  end
end
