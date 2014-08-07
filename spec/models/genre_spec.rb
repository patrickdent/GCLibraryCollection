require 'spec_helper'

describe Genre do

  let(:genre) { FactoryGirl.create(:genre) }


  subject { genre }

  describe "accessible attributes" do 
    its(:name) { should == genre.name }
  end

  describe "validations" do
    it "will not create a second genre with exact same name" do 
      count = Genre.count  
      genre2 = FactoryGirl.create(:genre)

      expect(Genre.count).to eq count
    end
    it "will not create an genre without a name" do 
      count = Genre.count  
      genre2 = FactoryGirl.create(:genre, name: "")

      expect(Genre.count).to eq count
    end  
  end 

end