class AddLanguageToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :language, :string
  end

  def self.down
    remove_column :profiles, :language
  end
end
