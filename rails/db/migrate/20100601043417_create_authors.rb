class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors, :force => true do |t| 
      t.column :first_name,   :string
      t.column :last_name,    :string
      t.column :type,         :string

      t.column :city,        :string
      t.column :state,       :string
      t.column :country,     :string
      t.column :region,      :string

      t.column :school,      :string
      t.column :grade,       :string
      t.column :major,       :string
      
      t.column :image_url,   :string
      t.column :summary,     :string
      
      t.timestamps
    end
  end

  def self.down
    drop_table :authors
  end
end
