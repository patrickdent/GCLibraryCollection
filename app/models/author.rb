class Author < ActiveRecord::Base
  has_many :book_authors
  has_many :books, through: :book_authors 
  has_many :contributions, through: :book_authors

  validates :name, uniqueness: true, presence: true  

  def self.search(search)
    find(:all, conditions: ['lower(name) LIKE lower(?)', "%#{search}%"] )
  end
end
