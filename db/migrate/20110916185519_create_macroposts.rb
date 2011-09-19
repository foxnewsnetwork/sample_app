class CreateMacroposts < ActiveRecord::Migration
  def self.up
    create_table :macroposts do |t|
      t.text :content
      t.integer :user_id
      t.integer :location_id
      t.string :title

      t.timestamps
    end
    add_index :macroposts, :user_id
    add_index :macroposts, :created_at
    add_index :macroposts, :location_id
  end

  def self.down
    drop_table :macroposts
  end
end
