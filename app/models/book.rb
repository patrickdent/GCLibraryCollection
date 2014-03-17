class Book < ActiveRecord::Base
	belongs_to :genre
  has_many :book_authors
  has_many :authors, through: :book_authors

  # def initialize( aTitle )
  #   @title = aTitle
  # end

end
