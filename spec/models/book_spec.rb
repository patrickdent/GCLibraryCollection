require 'spec_helper'

describe Book do
  
  let(:book) { FactoryGirl.create(:book) }

  subject { book }

  describe "accessible attributes" do
    its(:title) { should == "Kittypuss: an History" }
    its(:isbn)  { should == "123456789" }
  end

    describe "validations" do
    it "will not create a book without a title" do 
      count = Book.count  
      FactoryGirl.create(:book, title: "")

      expect(Book.count).to eq count
    end 
  end 

end