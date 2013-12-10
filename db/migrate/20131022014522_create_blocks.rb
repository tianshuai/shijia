class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.string :title
      t.text :content
      t.string :mark,		null: false
      t.integer :kind,		null: false, default: 1
	  t.integer :user_id,	null: false

      t.timestamps
    end
	add_index :blocks, :mark, unique: true	
	add_index :blocks, :kind
  end
end
