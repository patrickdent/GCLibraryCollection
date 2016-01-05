def create_google_url(isbn)
  url = ("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&key=" + ENV['google_api_key'].to_s)
  return url
end

def create_google_stub(url, description)
  stub_request(:get, url).
    with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
    to_return(:status => 200, :body => return_json_body_for_google(description), :headers => {})
end

def return_json_body_for_google(description)
  case description
    when "exists"
      return '{
               "kind": "books#volumes",
               "totalItems": 1,
               "items": [
                {
                 "kind": "books#volume",
                 "id": "Nlx07yuLAZwC",
                 "etag": "BiLThu9D00M",
                 "selfLink": "https://www.googleapis.com/books/v1/volumes/Nlx07yuLAZwC",
                 "volumeInfo": {
                  "title": "Herding Cats",
                  "subtitle": "Multiparty Mediation in a Complex World",
                  "authors": [
                   "Chester A. Crocker",
                   "Fen Osler Hampson",
                   "Pamela R. Aall"
                  ],
                  "publisher": "US Institute of Peace Press",
                  "publishedDate": "1999",
                  "description": "An illustrious cast of practitioners describes their personal experiences in working to bring peace in significant conflicts across four continents. In each of the two dozen cases examined in this volume, mediation was a multiparty effort, involving a range of actors - individuals, states, international organizations, and nongovernmental organizations - working simultaneously or sequentially. The editors have framed the volume with discussions that link the practitioner cases to the scholarly literature on mediation, thereby situating the case studies in terms of theory while also drawing lessons for both scholars and practitioners that can help guide future endeavors. Main contents : Part I : Multiparty mediation : concepts, issues, strategies, and actors Part II : Conflict prevention and management Part III : Ending violent conflict: the road to settlement Part IV: Settlement and implementation Part V : Conclusion.",
                  "industryIdentifiers": [
                   {
                    "type": "ISBN_10",
                    "identifier": "1878379925"
                   },
                   {
                    "type": "ISBN_13",
                    "identifier": "9781878379924"
                   }
                  ],
                  "readingModes": {
                   "text": false,
                   "image": true
                  },
                  "pageCount": 735,
                  "printType": "BOOK",
                  "categories": [
                   "Law"
                  ],
                  "contentVersion": "0.0.1.0.preview.1",
                  "imageLinks": {
                   "smallThumbnail": "http://bks2.books.google.com/books?id=Nlx07yuLAZwC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
                   "thumbnail": "http://bks2.books.google.com/books?id=Nlx07yuLAZwC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
                  },
                  "language": "en",
                  "previewLink": "http://books.google.com/books?id=Nlx07yuLAZwC&printsec=frontcover&dq=isbn:1878379925&hl=&cd=1&source=gbs_api",
                  "infoLink": "http://books.google.com/books?id=Nlx07yuLAZwC&dq=isbn:1878379925&hl=&source=gbs_api",
                  "canonicalVolumeLink": "http://books.google.com/books/about/Herding_Cats.html?hl=&id=Nlx07yuLAZwC"
                 },
                 "saleInfo": {
                  "country": "US",
                  "saleability": "NOT_FOR_SALE",
                  "isEbook": false
                 },
                 "accessInfo": {
                  "country": "US",
                  "viewability": "PARTIAL",
                  "embeddable": true,
                  "publicDomain": false,
                  "textToSpeechPermission": "ALLOWED",
                  "epub": {
                   "isAvailable": false
                  },
                  "pdf": {
                   "isAvailable": false
                  },
                  "webReaderLink": "http://books.google.com/books/reader?id=Nlx07yuLAZwC&hl=&printsec=frontcover&output=reader&source=gbs_api",
                  "accessViewStatus": "SAMPLE",
                  "quoteSharingAllowed": false
                 },
                 "searchInfo": {
                  "textSnippet": "In each of the two dozen cases examined in this volume, mediation was a multiparty effort, involving a range of actors - individuals, states, international organizations, and nongovernmental organizations - working simultaneously or ..."
                 }
                }
               ]
              }'

    when "does not exist"
      return  '{
               "kind": "books#volumes",
               "totalItems": 0
              }'

    when "no authors"
      return '{
               "kind": "books#volumes",
               "totalItems": 1,
               "items": [
                {
                 "kind": "books#volume",
                 "id": "Nlx07yuLAZwC",
                 "etag": "BiLThu9D00M",
                 "selfLink": "https://www.googleapis.com/books/v1/volumes/Nlx07yuLAZwC",
                 "volumeInfo": {
                  "title": "Herding Cats",
                  "subtitle": "Multiparty Mediation in a Complex World",
                  "authors": [
                  ],
                  "publisher": "US Institute of Peace Press",
                  "publishedDate": "1999",
                  "description": "An illustrious cast of practitioners describes their personal experiences in working to bring peace in significant conflicts across four continents. In each of the two dozen cases examined in this volume, mediation was a multiparty effort, involving a range of actors - individuals, states, international organizations, and nongovernmental organizations - working simultaneously or sequentially. The editors have framed the volume with discussions that link the practitioner cases to the scholarly literature on mediation, thereby situating the case studies in terms of theory while also drawing lessons for both scholars and practitioners that can help guide future endeavors. Main contents : Part I : Multiparty mediation : concepts, issues, strategies, and actors Part II : Conflict prevention and management Part III : Ending violent conflict: the road to settlement Part IV: Settlement and implementation Part V : Conclusion.",
                  "industryIdentifiers": [
                   {
                    "type": "ISBN_10",
                    "identifier": "1878379925"
                   },
                   {
                    "type": "ISBN_13",
                    "identifier": "9781878379924"
                   }
                  ],
                  "readingModes": {
                   "text": false,
                   "image": true
                  },
                  "pageCount": 735,
                  "printType": "BOOK",
                  "categories": [
                   "Law"
                  ],
                  "contentVersion": "0.0.1.0.preview.1",
                  "imageLinks": {
                   "smallThumbnail": "http://bks2.books.google.com/books?id=Nlx07yuLAZwC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
                   "thumbnail": "http://bks2.books.google.com/books?id=Nlx07yuLAZwC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
                  },
                  "language": "en",
                  "previewLink": "http://books.google.com/books?id=Nlx07yuLAZwC&printsec=frontcover&dq=isbn:1878379925&hl=&cd=1&source=gbs_api",
                  "infoLink": "http://books.google.com/books?id=Nlx07yuLAZwC&dq=isbn:1878379925&hl=&source=gbs_api",
                  "canonicalVolumeLink": "http://books.google.com/books/about/Herding_Cats.html?hl=&id=Nlx07yuLAZwC"
                 },
                 "saleInfo": {
                  "country": "US",
                  "saleability": "NOT_FOR_SALE",
                  "isEbook": false
                 },
                 "accessInfo": {
                  "country": "US",
                  "viewability": "PARTIAL",
                  "embeddable": true,
                  "publicDomain": false,
                  "textToSpeechPermission": "ALLOWED",
                  "epub": {
                   "isAvailable": false
                  },
                  "pdf": {
                   "isAvailable": false
                  },
                  "webReaderLink": "http://books.google.com/books/reader?id=Nlx07yuLAZwC&hl=&printsec=frontcover&output=reader&source=gbs_api",
                  "accessViewStatus": "SAMPLE",
                  "quoteSharingAllowed": false
                 },
                 "searchInfo": {
                  "textSnippet": "In each of the two dozen cases examined in this volume, mediation was a multiparty effort, involving a range of actors - individuals, states, international organizations, and nongovernmental organizations - working simultaneously or ..."
                 }
                }
               ]
              }'
    else raise ArgumentError.new("Please provide a valid description of the book in your method call")
  end
end

def create_goodreads_url(isbn)
  url = ("https://www.goodreads.com/search.xml?key=" + ENV['good_reads_api_key'].to_s + "=&q=#{isbn}")
  return url
end

def create_goodreads_stub(url, description)
  stub_request(:get, url).
    with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
    to_return(:status => 200, :body => return_xml_body_for_goodreads(description), :headers => {})
end

def return_xml_body_for_goodreads(description)
  case description
    when "exists"
      return "<?xml version='1.0' encoding='UTF-8'?>
      <GoodreadsResponse>
        <Request>
          <authentication>true</authentication>
          <key><![CDATA[TKAQpgIzHcFYzNDx7LkoQ]]></key>
          <method><![CDATA[search_search]]></method>
        </Request>
        <search>
          <query><![CDATA[1878379925]]></query>
          <results-start>1</results-start>
          <results-end>1</results-end>
          <total-results>1</total-results>
          <source>Goodreads</source>
          <query-time-seconds>0.01</query-time-seconds>
          <results>
            <work>
              <id type='integer'>255333</id>
              <books_count type='integer'>3</books_count>
              <ratings_count type='integer'>12</ratings_count>
              <text_reviews_count type='integer'>1</text_reviews_count>
              <original_publication_year type='integer'>1999</original_publication_year>
              <original_publication_month type='integer'>11</original_publication_month>
              <original_publication_day type='integer'>1</original_publication_day>
              <average_rating>3.92</average_rating>
              <best_book type='Book'>
                <id type='integer'>263401</id>
                <title>Herding Cats: Multiparty Mediation in a Complex World</title>
                <author>
                  <id type='integer'>153858</id>
                  <name>Chester A. Crocker</name>
                </author>
                <image_url>https://s.gr-assets.com/assets/nophoto/book/111x148-bcc042a9c91a29c1d680899eff700a03.png</image_url>
                <small_image_url>https://s.gr-assets.com/assets/nophoto/book/50x75-a91bf249278a81aabab721ef782c4a74.png</small_image_url>
              </best_book>
            </work>

            </results>
            </search>

        </GoodreadsResponse>"
    when "does not exist"
      return  "<?xml version='1.0' encoding='UTF-8'?>
      <GoodreadsResponse>

        <Request>
            <authentication>true</authentication>
              <key><![CDATA[TKAQpgIzHcFYzNDx7LkoQ]]></key>
            <method><![CDATA[search_search]]></method>
          </Request>
          <search>
          <query><![CDATA[1878379925]]></query>
            <results-start>0</results-start>
            <results-end>0</results-end>
            <total-results>0</total-results>
            <source>Goodreads</source>
            <query-time-seconds>0.01</query-time-seconds>
            <results>
              <work>
                <id type='integer'></id>
                <books_count type='integer'></books_count>
                <ratings_count type='integer'></ratings_count>
                <text_reviews_count type='integer'></text_reviews_count>
                <original_publication_year type='integer'></original_publication_year>
                <original_publication_month type='integer'></original_publication_month>
                <original_publication_day type='integer'></original_publication_day>
                <average_rating></average_rating>
                <best_book type='Book'>
                  <id type='integer'></id>
                  <title></title>
                  <author>
                  </author>
                  <image_url></image_url>
                  <small_image_url></small_image_url>
                </best_book>
              </work>
            </results>
            </search>

        </GoodreadsResponse>"

    when "no authors"
      return "<?xml version='1.0' encoding='UTF-8'?>
      <GoodreadsResponse>

        <Request>
            <authentication>true</authentication>
              <key><![CDATA[TKAQpgIzHcFYzNDx7LkoQ]]></key>
            <method><![CDATA[search_search]]></method>
        </Request>
        <search>
          <query><![CDATA[1878379925]]></query>
          <results-start>1</results-start>
          <results-end>1</results-end>
          <total-results>1</total-results>
          <source>Goodreads</source>
          <query-time-seconds>0.01</query-time-seconds>
          <results>
            <work>
              <id type='integer'>255333</id>
              <books_count type='integer'>3</books_count>
              <ratings_count type='integer'>12</ratings_count>
              <text_reviews_count type='integer'>1</text_reviews_count>
              <original_publication_year type='integer'>1999</original_publication_year>
              <original_publication_month type='integer'>11</original_publication_month>
              <original_publication_day type='integer'>1</original_publication_day>
              <average_rating>3.92</average_rating>
              <best_book type='Book'>
                <id type='integer'>263401</id>
                <title>Herding Cats: Multiparty Mediation in a Complex World</title>
                <author>
                </author>
                <image_url>https://s.gr-assets.com/assets/nophoto/book/111x148-bcc042a9c91a29c1d680899eff700a03.png</image_url>
                <small_image_url>https://s.gr-assets.com/assets/nophoto/book/50x75-a91bf249278a81aabab721ef782c4a74.png</small_image_url>
              </best_book>
            </work>
          </results>
          </search>
        </GoodreadsResponse>"
    else raise ArgumentError.new("Please provide a valid description of the book in your method call")
  end
end

def create_worldcat_url(isbn)
  url = ("http://xisbn.worldcat.org/webservices/xid/isbn/#{isbn}?method=getMetadata&format=json&fl=*")
  return url
end

def create_worldcat_stub(url, description)
  stub_request(:get, url).
    with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
    to_return(:status => 200, :body => return_json_body_for_worldcat(description), :headers => {})
end

def return_json_body_for_worldcat(description)
  case description
    when "exists"
      return "{\n \"stat\":\"ok\",\n \"list\":[{\n\t\"url\":[\"http://www.worldcat.org/oclc/255913704?referer=xid\"],\n\t\"publisher\":\"United States Inst. of Peace Press\",\n\t\"form\":[\"BC\"],\n\t\"lccn\":[\"99035750\"],\n\t\"lang\":\"eng\",\n\t\"city\":\"Washington, DC\",\n\t\"author\":\"Chester A. Crocker ...eds\",\n\t\"ed\":\"3. printing\",\n\t\"year\":\"2003\",\n\t\"isbn\":[\"1878379925\"],\n\t\"title\":\"Herding cats : multiparty mediation in a complex world\",\n\t\"oclcnum\":[\"255913704\",\n\t \"476307942\",\n\t \"493892053\",\n\t \"181646423\",\n\t \"231934832\",\n\t \"41504459\",\n\t \"461504741\",\n\t \"717772717\",\n\t \"812373255\",\n\t \"835948255\"]}]}"
    when "does not exist"
      return "{\n \"stat\":\"unknownId\",\n \"list\":[{}]}"
    when "no authors"
      return "{\n \"stat\":\"ok\",\n \"list\":[{\n\t\"url\":[\"http://www.worldcat.org/oclc/255913704?referer=xid\"],\n\t\"publisher\":\"United States Inst. of Peace Press\",\n\t\"form\":[\"BC\"],\n\t\"lccn\":[\"99035750\"],\n\t\"lang\":\"eng\",\n\t\"city\":\"Washington, DC\",\n\t\"author\":\"\",\n\t\"ed\":\"3. printing\",\n\t\"year\":\"2003\",\n\t\"isbn\":[\"1878379925\"],\n\t\"title\":\"Herding cats : multiparty mediation in a complex world\",\n\t\"oclcnum\":[\"255913704\",\n\t \"476307942\",\n\t \"493892053\",\n\t \"181646423\",\n\t \"231934832\",\n\t \"41504459\",\n\t \"461504741\",\n\t \"717772717\",\n\t \"812373255\",\n\t \"835948255\"]}]}"
    else raise ArgumentError.new("Please provide a valid description of the book in your method call")
  end
end