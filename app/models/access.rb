class Access < ActiveRecord::Base
  belongs_to :role
  belongs_to :forum
end
