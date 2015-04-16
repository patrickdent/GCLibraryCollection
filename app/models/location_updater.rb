class LocationUpdater
  require 'csv'
  
  attr_accessor :failures

  def initialize
    @failures = Array.new
  end

  def update_locations
    print "Path to storage file:"
    storage_file = gets.strip
    print "Path to storage file:"
    missing_file = gets.strip

    storage_data = open_csv(storage_file)
    missing_data = open_csv(missing_file)

    storage_data.each { |book| update_storage_book(book) }
    missing_data.each { |book| update_missing_book(book) }

    puts "SOME FILES DIDN'T UPDATE CORRECTLY!!" unless @failures.empty?
    puts "Everything went swimmingly" if @failures.empty?
  end

  def open_csv(file)
    unassigned_data = CSV.read(file, encoding: "bom|utf-8")

    unassigned_data[0].each { |col| col = col.downcase! }
    headers = unassigned_data.delete_at(0)
    data = unassigned_data.map! { |user| Hash[headers.zip(user)] }
    return data
  end

  def update_storage_book(book_info)
    if book = Book.find_by_title_and_isbn(book_info["title"], book_info["isbn"])
      book.update_attributes(in_storage: true, location: book_info["owner"])
    else
      failures << [book_info["title"], book_info["isbn"], book_info["location"]]
    end
  end

  def update_missing_book(book_info)
    if book = Book.find_by_title_and_isbn(book_info["title"], book_info["isbn"])
      book.update_attributes(missing: true, available: false)
    else
      failures << [book_info["title"], book_info["isbn"], book_info["location"]]
    end
  end  
  
end
