class Forum < ActiveRecord::Base
  belongs_to :category
  has_many :topics

  validates_presence_of :name, :description

  attr_accessible :name, :description

  def paginate_topics_sorted(per_page, current)
    topics.find :all, :include => :posts, :order => "posts.created_at DESC", :page => { :size => per_page, :first => 1, :current => current }
  end

  def posts_count()
    Post.count :include => "topic", :conditions => ["topics.forum_id = ?", self]
  end

  def last_post()
    Post.find :first, :include => "topic", :conditions => ["topics.forum_id = ?", self.id], :order => "posts.created_at DESC"
  end

end
