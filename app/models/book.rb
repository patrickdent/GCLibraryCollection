class Book < ActiveRecord::Base
	belongs_to :genre
  has_many :book_authors
  has_many :authors, through: :book_authors
  has_many :book_keywords
  has_many :keywords, through: :book_keywords

  validates :title, presence: true 

  def self.search(search)
    find(:all, conditions: ['lower(title) LIKE lower(?)', "%#{search}%"] )
  end


end
