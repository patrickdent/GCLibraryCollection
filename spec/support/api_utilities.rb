def create_google_url(isbn)
  url = ("https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&key=" + ENV['google_api_key'].to_s)
  return url
end

def create_google_stub(url, description)
  stub_request(:get, url).
    with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
    to_return(:status => 200, :body => return_json_body(description), :headers => {})
end


def return_json_body(description)
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
