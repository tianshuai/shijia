class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.string :title
      t.string :content
      t.string :address
      t.integer :user_id,			null: false
      t.integer :column_space_id,	null: false, default: 0
      t.integer :kind,				null: false, default: 1
      t.integer :state,				null: false, default: 0
      t.integer :sort,				null: false, default: 0

      t.timestamps
    end
	add_index :columns, :column_space_id
	add_index :columns, :kind
  end
end
