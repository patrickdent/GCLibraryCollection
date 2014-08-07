require 'spec_helper'

describe Book do
  
  let(:book) { FactoryGirl.create(:book, title: "Kittypuss: an History", isbn: "123456789" ) }

  subject { book }

  describe "accessible attributes" do
    its(:title) { should == "Kittypuss: an History" }
    its(:isbn)  { should == "123456789" }
  end

    describe "validations" do
    it "will not create a book without a title" do  
      FactoryGirl.build(:book, title: "").should_not be_valid
    end 
  end 

end