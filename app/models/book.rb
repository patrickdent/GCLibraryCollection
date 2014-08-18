class Book < ActiveRecord::Base
	belongs_to :genre
  has_many :book_authors
  has_many :authors, through: :book_authors

  validates :title, presence: true 

  def self.search(search)
    find(:all, conditions: ['lower(title) LIKE lower(?)', "%#{search}%"] )
  end


end
