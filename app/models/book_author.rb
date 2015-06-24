class BookAuthor < ActiveRecord::Base
  belongs_to :author 
  belongs_to :book 
  belongs_to :contribution

  def self.update_or_delete_from_book(book, ids)
    if ids.nil?
      book.book_authors.each { |b| b.delete }
    else
      book.book_authors.update ids.keys, ids.values

      book_author_ids = book.book_authors.map { |b| b.id }
      to_remove = book_author_ids.reject { |id| ids.keys.include?(id.to_s) }
      to_remove.each { |a| BookAuthor.find(a).delete }
    end
  end

  def self.create_multi(book, hash)
    hash.each_value do |a|
      BookAuthor.create( book_id: book.id, author_id: a[:author_id], contribution_id: a[:contribution_id], primary: a[:primary] )
    end
  end
end
