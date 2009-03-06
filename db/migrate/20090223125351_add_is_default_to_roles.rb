class AddIsDefaultToRoles < ActiveRecord::Migration
  def self.up
    add_column :roles, :is_default, :boolean
  end

  def self.down
    remove_column :roles, :is_default
  end
end
