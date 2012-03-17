class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.belongs_to :book
      t.integer :page_number
      t.text :content

      t.timestamps
    end
    add_index :pages, :book_id
  end
end
