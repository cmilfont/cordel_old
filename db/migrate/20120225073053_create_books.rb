class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.belongs_to :author
      t.integer :year
      t.integer :edition
      t.string :publisher

      t.timestamps
    end
    add_index :books, :author_id
  end
end
