class ShelvedBook < ActiveRecord::Base
  belongs_to :book
  belongs_to :shelf
end
