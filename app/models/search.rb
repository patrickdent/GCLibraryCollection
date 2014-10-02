class Search
  require 'net/http'

  def scrape(isbn)
      # isbn = '0374399387'
      url = URI.parse("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&key=")
      req = Net::HTTP::Get.new(url.to_s + ENV['google_api_key'])
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      response = http.request(req)
      body = response.body
      temp_hash = JSON.parse(body)
      book_hash = temp_hash["items"].first["volumeInfo"]
      authors = temp_hash["items"].first["volumeInfo"]["authors"]
      # book_info = Array.new
      # body.each_line do |l|
      #   #can also do publisher, publishedDate, pageCount, 
      #   if ((l.include? "title") || (l.include? "description") ||
      #       (l.include? "publisher") || (l.include? "publishedDate") ||
      #       (l.include? "pageCount")) then
      #     l.strip!
      #     l.delete! "\""
      #     book_info << l
      #   end
      # end
      # book_hash = Hash.new
      # book_info.each do |l|
      #   pair = l.split ":"
      #   pair[1].strip!
      #   pair[1].slice!(-1)
      #   book_hash[pair[0].to_sym] = pair[1]
      # end

      puts book_hash
      puts authors
  end
end
