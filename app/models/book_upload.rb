class BookUpload < ActiveRecord::Base

  include Uploadable

  def make_object(book_data)
    return false if book_data["title"] == false

    unless book_data["isbn"].empty? || book_data["isbn"].nil?
      if (book = Book.find_by_isbn(book_data["isbn"]))
        book.count += 1
        book.update_availability
        return
      end
    end

    book = Book.create( title:  book_data["title"],
                        genre:  find_or_make_genre(book_data["genre"]),
                        publisher: book_data["publisher"],
                        publish_date:  book_data["publish date"],
                        isbn: book_data["isbn"])

    @new_objects << book.id

    if book_data["author"]
      make_authors(book_data["author"]).each do |auth|
        BookAuthor.create(book: book, author: auth)
      end
    end
  end

  def make_authors(names)
    names.split(';').map! { |name| Author.find_or_create_by(name: name) }
  end

  def find_or_make_genre(genre_data)
    return Genre.find(self.genre.to_i) if self.genre && !self.genre.empty?
    return Genre.find_by_name("Unassigned") if genre_data.nil? || genre_data.empty?

    genre_data.gsub!('missing', '')
    genre_data.strip

    genre = Genre.find_by_name("Unassigned") if genre_data == "" || genre_data == "Unassigned"
    genre ||= (Genre.find_by_name(genre_data) || Genre.create(name: genre_data, abbreviation: genre_data))
  end

  def self.import_requirements?(params)
    params[:book_upload].has_key?(:file) && params[:book_upload][:file] != nil
  end
end

