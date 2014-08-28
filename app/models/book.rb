class Book < ActiveRecord::Base
	belongs_to :genre
  has_many :book_authors
  has_many :authors, through: :book_authors

  validates :title, presence: true 

  def self.search(search)
    search_length = search.split.length
    where([(['lower(title) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" })
  end


end
