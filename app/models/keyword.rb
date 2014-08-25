class Keyword < ActiveRecord::Base
  # has_many :book_authors
  # has_many :books, through: :book_authors 

  validates :keyword, uniqueness: true, presence: true  

end