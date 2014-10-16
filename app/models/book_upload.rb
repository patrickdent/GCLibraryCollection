class BookUpload < ActiveRecord::Base

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  require 'csv'

  def save
    @new_books = Array.new
    if imported_books.each { |i| make_book(i) }
      @new_books
      # true 
    else
      imported_books.each_with_index do |product, index|
        product.errors.full_messages.each do |message|
          errors.add :base, "Row #{index+2}: #{message}"
        end
      end
      false
    end
  end

  def imported_books
    @imported_books ||= load_imported_books
  end

  def load_imported_books
    unassigned_data = open_spreadsheet
    #sets the headers to symbols and removes them from the array of data
    unassigned_data[0].each { |col| col = col.downcase! }
    headers = unassigned_data.delete_at(0)

    #making the arr_of_arr into an array of hashes with the header as keys
    #as a preliminary step to creating book objects
    books = unassigned_data.map! { |book| Hash[headers.zip(book)] }
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when ".csv" then CSV.read(file.path, encoding: "bom|utf-8")
    when ".txt" then CSV.read(file.path, encoding: "bom|utf-8")
    # when ".xls" then Excel.new(file.path, nil, :ignore)
    # when ".xlsx" then Excelx.new(file.path, nil, :ignore)
    # else raise "Unknown file type: #{file.original_filename}"
    else raise InvalidFileError
    end
  end

  def make_book(book_data)
    return false if book_data["title"] == false

    book = Book.create( title:  book_data["title"],
                        genre:  Genre.find_by_name(genre),
                        publisher: book_data["publisher"],
                        publish_date:  book_data["publish date"],
                        publication_place:  book_data["publication place"],
                        isbn: book_data["isbn"])
    
    # => I can't decide which is asier to read: 
    # => the commented line below or the uncommented one after
    # (make_authors(book_data["author"])).each { |n| book.authors << n } if book_data["author"] != nil
    
    # adds the actrive record id to an array of all the books created this session
    @new_books << book.id

    if (a = book_data["author"]) != nil then (make_authors(a)).each { |n| book.authors << n } end
    
  end

  def make_authors(names)
    authors = names.split(';').map! do |name|
      (n = Author.find_by_name(name)) != nil ? name = n : Author.create(name: name)
    end
  end

  def make_genre(name)
  end
  
  def self.import_requirements?(params)
    if params[:book_upload].has_key?(:file) && !params[:book_upload][:genre].blank?
      true
    else
      false
    end
  end

  class InvalidFileError < RuntimeError
  end
end

