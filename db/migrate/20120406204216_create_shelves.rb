class CreateShelves < ActiveRecord::Migration
  def change
    create_table :shelves do |t|
      t.string :name
      t.belongs_to :user

      t.timestamps
    end
    add_index :shelves, :user_id
  end
end
