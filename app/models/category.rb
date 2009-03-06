class Category < ActiveRecord::Base
  has_many :forums

  validates_presence_of :name

  attr_accessible :name
end
