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

  #preferred method; has most important fields
  def self.google_api(isbn)
    url = URI.parse("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&key=")
    req = Net::HTTP::Get.new(url.to_s + ENV['google_api_key'].to_s)
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

  #not the best, authors is non-standardized - can't be parsed
  def self.world_cat_api(isbn)
    url = URI.parse("http://xisbn.worldcat.org/webservices/xid/isbn/#{isbn}?method=getMetadata&format=json&fl=*")
    req = Net::HTTP::Get.new(url.to_s)
    http = Net::HTTP.new(url.host, url.port)
    response = http.request(req)
    body = response.body
    book_hash = JSON.parse(body)["list"].first

    world_cat_info = Hash.new
    world_cat_info["title"] = book_hash["title"]
    world_cat_info["publisher"] = book_hash["publisher"]
    world_cat_info["language"] = book_hash["lang"]
    world_cat_info["publish_date"] = book_hash["year"]
    world_cat_info["publish_place"] = book_hash["city"]

    return world_cat_info
  end
end
