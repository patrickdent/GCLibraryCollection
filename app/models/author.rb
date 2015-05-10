class Author < ActiveRecord::Base
  has_many :book_authors
  has_many :books, through: :book_authors
  has_many :contributions, through: :book_authors

  validates :name, uniqueness: true, presence: true

  after_create :sort_by_name

  def self.search(search)
    search_length = search.split.length
    where([(['lower(name) LIKE lower(?)'] * search_length).join(' AND ')] + search.split.map { |search| "%#{search}%" }).order(:name)

  end

  def sort_by_name
    if !sort_by || sort_by.empty? || sort_by.first == "("
      last_string = name.split(" ").last
      if last_string.first == "("
        update_attribute(:sort_by, name.split(" ")[-2])
      else
        update_attribute(:sort_by, last_string)
      end
    end
    return sort_by
  end

  def display_name
    "#{sort_by_name}, #{name.split(" ").first}"
  end
end
