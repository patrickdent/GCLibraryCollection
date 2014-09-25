class Search
  require 'net/http'

  def scrape
    # get https://www.googleapis.com/books/v1/volumes?q=isbn:9780547539638&key=ENV['google_api_key']
    # begin
      isbn = '0374399387'
      url = URI.parse("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&key=")
      req = Net::HTTP::Get.new(url.to_s + ENV['google_api_key'])
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      response = http.request(req)
      puts response.body
    # rescue URI::InvalidURIError
    #   host = url.match(".+\:\/\/([^\/]+)")[1]
    #   path = url.partition(host)[2] || "/"
    #   Net::HTTP.get host, path
    # end
  end
end
