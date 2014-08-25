class BookKeyword < ActiveRecord::Base
  belongs_to :keyword 
  belongs_to :book 
end
