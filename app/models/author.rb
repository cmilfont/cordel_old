class Author < ActiveRecord::Base
  
  searchable do
    text :name
  end
  
end
