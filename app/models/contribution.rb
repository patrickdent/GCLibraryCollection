class Contribution < ActiveRecord::Base
  has_many :book_authors
  has_many :authors, through: :book_authors
  
  validates :name, uniqueness: true, presence: true  
end
