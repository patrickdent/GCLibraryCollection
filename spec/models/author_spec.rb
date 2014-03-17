require 'spec_helper'

describe Author do
  
  let(:author) { FactoryGirl.create(:author) }

  subject { author }

  describe "accessible attributes" do
    its(:name) { should == "Chairman Meow" }
  end

end