class Keyword < ActiveRecord::Base
  has_many :book_keywords
  has_many :books, through: :book_keywords

  validates :name, uniqueness: true, presence: true

  def self.search(search)
    search_length = search.split.length
    where([(['lower(name) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" }).order(:name)
  end

end