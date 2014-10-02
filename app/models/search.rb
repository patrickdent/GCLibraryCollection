class Search
  require 'net/http'

  def self.scrape(isbn)
    return nil if Book.find_by(isbn: isbn)

    google_info = google_api(isbn)
    
    return nil if google_info == nil 

    b = Book.new
    b.title = google_info["title"]
    b.publisher = google_info["publisher"]
    b.publish_date = google_info["publishedDate"]
    b.language = google_info["lang"]
    b.pages = google_info["pageCount"]
    b.isbn = isbn
    authors = google_info["authors"]
    if authors 
      authors.each do |name|
        a = Author.find_or_create_by(name: name)
        b.authors << a
      end
    end 
    b.save!
  
    return b
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

    return nil if temp_hash["totalItems"] == 0        

    book_hash = temp_hash["items"].first["volumeInfo"]

    google_info = Hash.new 
    google_info["title"] = book_hash["title"]
    google_info["publisher"] = book_hash["publisher"]
    google_info["publish_date"] = book_hash["publishedDate"]
    google_info["language"] = book_hash["lang"]
    google_info["pages"] = book_hash["pageCount"]
    google_info["isbn"] = isbn
    google_info["authors"] = temp_hash["items"].first["volumeInfo"]["authors"]

    return google_info
  end
end
