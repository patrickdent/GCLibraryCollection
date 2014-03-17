require 'spec_helper'

describe Book do
  
  let(:book) { FactoryGirl.create(:book) }

  subject { book }

  describe "accessible attributes" do
    its(:title) { should == "Kittypuss: an History" }
    its(:isbn)  { should == "123456789" }
  end

end