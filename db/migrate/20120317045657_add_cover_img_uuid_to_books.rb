class AddCoverImgUuidToBooks < ActiveRecord::Migration
  def change
    add_column :books, :cover_img_uuid, :string
    add_column :books, :index_erro, :string
  end
end
