class Book < ActiveRecord::Base
	belongs_to :genre
  has_many :book_authors
  has_many :authors, through: :book_authors
  has_many :book_keywords
  has_many :keywords, through: :book_keywords
  has_many :contributions, through: :book_authors
  has_many :loans
  has_many :users, through: :loans

  scope :available_to_loan, -> { where(available: true ) }

  validates :title, presence: true 

  def self.search(search)
    search_length = search.split.length
    where([(['lower(title) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" })
  end

  def update_availability
    if self.count <= self.loans.active.count
      update_attribute(:available, false)
    elsif self.count > self.loans.active.count
      update_attribute(:available, true)
    end 
  end 

end
