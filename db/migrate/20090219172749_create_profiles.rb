class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :real_name
      t.string :location
      t.string :website
      t.string :signature
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
