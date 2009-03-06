class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.boolean :is_admin
      t.integer :rights_to_own_topic
      t.integer :rights_to_other_topic
      t.integer :rights_to_own_post
      t.integer :rights_to_other_post

      t.timestamps
    end
  end

  def self.down
    drop_table :roles
  end
end
