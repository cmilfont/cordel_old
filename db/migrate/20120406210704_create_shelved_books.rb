class CreateShelvedBooks < ActiveRecord::Migration
  def change
    create_table :shelved_books do |t|
      t.belongs_to :book
      t.belongs_to :shelf

      t.timestamps
    end
    add_index :shelved_books, :book_id
    add_index :shelved_books, :shelf_id
  end
end
