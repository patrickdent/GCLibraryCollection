require 'spec_helper'

describe Genre do

  let(:genre) { FactoryGirl.create(:genre) }


  subject { genre }

  describe "accessible attributes" do 
    its(:name) { should == genre.name }
  end

end