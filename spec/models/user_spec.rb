require 'spec_helper'

describe User do
  
  let(:user) { create :user }

  subject { user }

  describe "accessible attributes" do
    it { should respond_to(:email) }
    it { should respond_to(:notes) }
    it { should respond_to(:name) }
    it { should respond_to(:phone) }
    it { should respond_to(:sort_by) }
    it { should respond_to(:address) }
    it { should respond_to(:do_not_lend) }
    it { should respond_to(:identification) }
  end
  
end