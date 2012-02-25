class Book < ActiveRecord::Base
  
  belongs_to :author
  
  has_attached_file :file
  validates_attachment_presence :file
  validates_attachment_size :file, :less_than => 7.megabytes
  validates_attachment_content_type :file, :content_type => ['application/pdf']
  
  
end
