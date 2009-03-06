class Post < ActiveRecord::Base
  belongs_to :topic
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"

  validates_presence_of :body

  attr_accessible :body

end
