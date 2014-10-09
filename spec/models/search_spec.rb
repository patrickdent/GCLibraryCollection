require 'spec_helper'
require 'support/utilities'

describe Search do

  let(:isbn) { "1234567890" }
  let(:url) { "https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&key=" + ENV['google_api_key'] }
  let(:title) { "Cute Title" }
  let(:publisher) { "Cute Publisher" }
  let(:publishedDate) { "Cute Date" }
  let(:lang) { "Cute Language" }
  let(:pageCount) { "Cute Number" }
  let(:authors) { ["Cute Authors"] }
  
  
  describe "scrape" do

    before do
      stub_request(:get, url).
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => return_json_body, :headers => {})
    end

    context "good info" do

      it "will make a book from good info" do  
        expect(Search.scrape(isbn)).to eq Book.last
      end 

      it "will find authors from good info" do  

      end 

      it "will make authors from good info" do  

      end 
    end 
    
    it "will return nil if no book info comes back" do  

    end 

    it "will not error if no author info present" do  

    end 

    it "will return nil if book with isbn already exists" do 

    end 
  end 
end