class Role < ActiveRecord::Base
  include RorumMisc

  has_many :permissions
  has_many :users, :through => :permissions
  has_many :accesses
  has_many :forums, :through => :accesses

  validates_presence_of :name
  rights_accessor :rights_to_own_topic, :rights_to_other_topic, :rights_to_own_post, :rights_to_other_post

  attr_accessible :name, :is_admin, :forum_ids, :is_default
  rights_accessible :rights_to_own_topic, :rights_to_other_topic, :rights_to_own_post, :rights_to_other_post

  def right_to?(is_owner, resource, operation)
    case resource
    when :topic
      (is_owner ? self.rights_to_own_topic : self.rights_to_other_topic)&(1 << RIGHTS[operation]) != 0
    when :post
      (is_owner ? self.rights_to_own_post : self.rights_to_other_post)&(1 << RIGHTS[operation]) != 0
    end
  end

  def forum_ids()
    self.forums.collect { |forum| forum.id }
  end

  def forum_ids=(forum_ids)
    unless forum_ids.nil?
      self.forums = forum_ids.collect { |forum_id| Forum.find(forum_id) }
    end
  end

  def after_initialize()
    self.is_admin ||= false
    self.rights_to_own_topic ||= 0
    self.rights_to_other_topic ||= 0
    self.rights_to_own_post ||=0
    self.rights_to_other_post ||= 0
  end

end
