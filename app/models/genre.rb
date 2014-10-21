class Genre < ActiveRecord::Base
	has_many :books

  validates :name, uniqueness: true, presence: true
  validates :abbreviation, uniqueness: true 

  def self.search(search)
    search_length = search.split.length
    where([(['lower(name) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" })
  end
end
