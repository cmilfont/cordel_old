class Page < ActiveRecord::Base
  belongs_to :book
  
  searchable do
    integer :page_number
    integer :book_id, :references => Book
    text :content
  end
  
end
