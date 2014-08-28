class Keyword < ActiveRecord::Base
  has_many :book_keywords
  has_many :books, through: :book_keywords

  validates :keyword, uniqueness: true, presence: true  

end