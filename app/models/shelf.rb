class Shelf < ActiveRecord::Base
    
  validates_presence_of :name
  
  belongs_to :user
  validates_presence_of :user
  
  has_many :shelved_books
  has_many :books, :through => :shelved_books
  
end
