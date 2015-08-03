class Author < ActiveRecord::Base
  self.primary_key = 'id'

  has_many :book_authors, dependent: :destroy
  has_many :books, through: :book_authors
  has_many :contributions, through: :book_authors

  validates :name, uniqueness: true, presence: true

  after_create :sort_by_name

  def self.search(search)
    search_length = search.split.length
    where([(['lower(name) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" }).order(:name)

  end

  def sort_by_name
    update_attribute(:sort_by, name.split(" ").last) unless (sort_by && !sort_by.empty?)
    return sort_by
  end

  def display_name
    name_arr = name.split(" ")
    "#{name_arr[-1]}, #{name_arr.first(name_arr.size - 1).join(" ")}"
  end
end
