class Profile < ActiveRecord::Base
  belongs_to :user
  has_attached_file :avatar, :styles => { :small => "100x100>" }

  validates_attachment_size :avatar, :less_than => 200.kilobytes
  validates_attachment_content_type :avatar, :content_type => ["image/jpeg", "image/png", "image/gif"]

  def self.paginate_find_sorted(per_page, current)
    self.find :all, :include => :user, :order => "users.login ASC", :page => { :size => per_page, :first => 1, :current => current }
  end
end
