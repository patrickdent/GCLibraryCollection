class Genre < ActiveRecord::Base
	has_many :books

  validates :name, uniqueness: true, presence: true 
end
