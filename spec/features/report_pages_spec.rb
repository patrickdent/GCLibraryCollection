require 'spec_helper'

describe 'Report Pages', type: feature do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end
  subject { page }

  describe 'dashboard' do
    before do
      admin_login
      visit reports_path
    end

    it 'displays title' do expect(subject).to have_selector('h2', 'Build Your Report') end


  end

end