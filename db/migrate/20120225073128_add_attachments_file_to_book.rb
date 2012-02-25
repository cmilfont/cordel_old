class AddAttachmentsFileToBook < ActiveRecord::Migration
  def self.up
    change_table :books do |t|
      t.has_attached_file :file
    end
  end

  def self.down
    drop_attached_file :books, :file
  end
end
