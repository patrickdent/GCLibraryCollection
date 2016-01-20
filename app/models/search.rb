class Search
  require 'net/http'

  def self.scrape(isbn)
    if (book = Book.find_by(isbn: isbn)) then
      book.update_attributes(count: book.count + 1)
      return book
    end

    good_reads_info = good_reads_api(isbn)
    google_info = google_api(isbn)
    world_cat_info = world_cat_api(isbn)

    joined_hash = google_info.merge(good_reads_info).merge(world_cat_info)

    return nil if joined_hash.empty?

    return create_book(joined_hash, isbn)
  end

  private

  def self.create_book(book_info, isbn)
    return nil unless book_info
    book_info["isbn"] = isbn
    authors = book_info.delete("authors")
    b = Book.create(book_info)
    build_book_authors(b, authors) if b.id && authors
    return b
  end

  def self.build_book_authors(book, authors)
    authors.each do |name|
      a = Author.find_or_create_by(name: name)
      BookAuthor.create(author: a, book: book)
    end
  end

  def self.google_api(isbn)
    url = URI.parse("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&key=")
    req = Net::HTTP::Get.new(url.to_s + ENV['google_api_key'].to_s)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.request(req)
    body = response.body
    temp_hash = JSON.parse(body)

    return {} if temp_hash["totalItems"] == 0

    book_hash = temp_hash["items"].first["volumeInfo"]
    # temp_hash["items"].first["volumeInfo"]["categories"] may be a source for keywords
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

  def self.good_reads_api(isbn)
    url = URI.parse("https://www.goodreads.com/search.xml?key=#{ENV['good_reads_api_key']}=&q=#{isbn}")
    req = Net::HTTP::Get.new(url.to_s)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.request(req)
    body = response.body
    temp_hash = Hash.from_xml(body)
    book_hash = temp_hash['GoodreadsResponse']['search']['results']['work']

    return {} unless book_hash.class == "Hash"
    return {} unless book_hash['id']

    good_reads_info = Hash.new
    good_reads_info['publish_date'] = book_hash['original_publication_year']
    good_reads_info['title'] = book_hash['best_book']['title']
    good_reads_info['title'] = book_hash['best_book']['title']
    good_reads_info['authors'] = [book_hash['best_book']['author']['name']]

    return good_reads_info
  end

  def self.world_cat_api(isbn)
    url = URI.parse("http://xisbn.worldcat.org/webservices/xid/isbn/#{isbn}?method=getMetadata&format=json&fl=*")
    req = Net::HTTP::Get.new(url.to_s)
    http = Net::HTTP.new(url.host, url.port)
    response = http.request(req)
    body = JSON.parse(response.body)

    return {} if body['stat'] == "unknownId" || body['stat'] == "invalidId"

    book_hash = body["list"].first

    world_cat_info = Hash.new
    world_cat_info["title"] = book_hash["title"]
    world_cat_info["publisher"] = book_hash["publisher"]
    world_cat_info["language"] = book_hash["lang"]
    world_cat_info["publish_date"] = book_hash["year"]
    world_cat_info["publication_place"] = book_hash["city"]

    return world_cat_info
  end
end
