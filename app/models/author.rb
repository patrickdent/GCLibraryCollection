class Author < ActiveRecord::Base
  has_many :book_authors
  has_many :books, through: :book_authors 
  has_many :contributions, through: :book_authors

  validates :name, uniqueness: true, presence: true  

  def self.search(search)
    search_length = search.split.length
    where([(['lower(name) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" })

  end

  def sort_by_name
    return sort_by if sort_by
    update_attribute(:sort_by, name.split(" ").last)
  end
end
