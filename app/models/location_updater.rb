class LocationUpdater
  require 'csv'

  def self.update_locations
    print "Name of file:"
    file = gets.strip
    data = LocationUpdater::open_csv(file)

    data.each { |book| LocationUpdater::update_book(book) }
    # puts data
  end

  def self.open_csv(file)
    unassigned_data = CSV.read(file, encoding: "bom|utf-8")

    unassigned_data[0].each { |col| col = col.downcase! }
    headers = unassigned_data.delete_at(0)
    data = unassigned_data.map! { |user| Hash[headers.zip(user)] }
    return data
  end

  def self.update_book(book_info)
    book = Book.find_by_title_and_isbn(book_info["title"], book_info["isbn"])
    book.update_attributes(in_storage: true, location: book_info["owner"])
    puts book.location
  end  
end
