class Search
  require 'net/http'

  def self.scrape(isbn)
    return if Book.find_by(isbn: isbn)
    google_api(isbn)
  end

  private

  def self.google_api(isbn)
    url = URI.parse("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&key=")
    req = Net::HTTP::Get.new(url.to_s + ENV['google_api_key'])
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.request(req)
    body = response.body
    temp_hash = JSON.parse(body)
    book_hash = temp_hash["items"].first["volumeInfo"]
    authors = temp_hash["items"].first["volumeInfo"]["authors"]
    
    b = Book.new
    b.title = book_hash["title"]
    b.publisher = book_hash["publisher"]
    b.publish_date = book_hash["publishedDate"]
    b.language = book_hash["lang"]
    b.pages = book_hash["pageCount"]
    b.isbn = isbn
    authors.each do |name|
      a = Author.find_or_create_by(name: name)
      b.authors << a
    end
    b.save!
    return b
  end
end
