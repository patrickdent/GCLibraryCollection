require 'spec_helper'

describe 'User Pages', type: feature do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  let!(:user) { create(:user) }

  describe 'index' do
    it 'displays "patron" as role of user with no role' do
      admin_login
      visit users_path
      expect(page).to have_content("patron")
      expect(page.all('table tbody tr').count).to eq(User.all.length)
    end
  end
end