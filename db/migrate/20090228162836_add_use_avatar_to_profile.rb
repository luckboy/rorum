class AddUseAvatarToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :use_avatar, :boolean
  end

  def self.down
    remove_column :profiles, :use_avatar
  end
end
