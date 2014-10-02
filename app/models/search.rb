class Search
  require 'net/http'

  def scrape
      isbn = '0374399387'
      url = URI.parse("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&key=")
      req = Net::HTTP::Get.new(url.to_s + ENV['google_api_key'])
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      response = http.request(req)
      body = response.body
      lines = Array.new
      body.each_line do |l|
        if ((l.include? "title") || (l.include? "description")) then
          l.strip!
          l.delete! "\""
          lines << l
        end
      end
      hash = Hash.new
      lines.each do |l|
        pair = l.split ":"
        pair[1].strip!
        pair[1].slice!(-1)
        hash[pair[0].to_sym] = pair[1]
      end

      # body.delete! "\""
      # body.delete! "{"
      # body.delete! "}"
      # puts body
      # return body
      # puts response.body
      # return response
      return hash
  end
end
