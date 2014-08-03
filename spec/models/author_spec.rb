require 'spec_helper'

describe Author do
  
  let(:author) { FactoryGirl.create(:author) }

  subject { author }

  describe "accessible attributes" do
    its(:name) { should == "Chairman Meow" }
  end

  describe "validations" do
    it "will not create a second author with exact same name" do 
      count = Author.count  
      author2 = FactoryGirl.create(:author)

      expect(Author.count).to eq count
    end
    it "will not create an author without a name" do 
      count = Author.count  
      author2 = FactoryGirl.create(:author, name: "")

      expect(Author.count).to eq count
    end  
  end 

end