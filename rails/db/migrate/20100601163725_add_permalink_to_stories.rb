class AddPermalinkToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :permalink, :string
  end

  def self.down
    remove_column :stories, :permalink
  end
end
