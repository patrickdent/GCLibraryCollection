class Author < ActiveRecord::Base
  has_many :book_authors
  has_many :books, through: :book_authors 

  def self.search(search)
    find(:all, conditions: ['name LIKE ?', "%#{search}%"] )
  end
end
