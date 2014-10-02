require 'spec_helper'

describe Search do

  describe "scrape" do
    context "good info" do 
      before do 
        Search.scrape.stub(:message) { 'this is the value to return' }
      end 

      it "will make a book from good info" do  

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