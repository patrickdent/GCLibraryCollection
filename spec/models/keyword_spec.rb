require 'spec_helper'

describe Keyword  do
  let(:keyword) { FactoryGirl.create(:keyword) }

  subject { keyword }

  describe "accessible attributes" do
    it { should respond_to(:keyword) }
    its(:keyword) { should == "keyword" }
  end


end