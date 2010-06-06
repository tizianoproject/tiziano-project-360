class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.string :title
      t.string :headline
      t.string :subhead
      t.string :text
      t.integer :author_id

      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end
