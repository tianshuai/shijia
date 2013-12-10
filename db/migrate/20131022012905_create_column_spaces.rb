class CreateColumnSpaces < ActiveRecord::Migration
  def change
    create_table :column_spaces do |t|
      t.string :name
      t.string :content
      t.string :mark,				null: false
      t.integer :user_id,			null: false
      t.integer :kind,				null: false, default: 1
	  t.integer :state,				null: false, default: 1
	  t.integer :width,				null: false, default: 0
	  t.integer :height,			null: false, default: 0

      t.timestamps
    end
	add_index :column_spaces, :mark, unique: true
	add_index :column_spaces, :kind
  end
end
