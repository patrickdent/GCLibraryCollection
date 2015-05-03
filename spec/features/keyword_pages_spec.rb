require 'spec_helper'

describe 'Keyword Pages', type: feature do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  after :each do
    DatabaseCleaner.clean
  end

  let(:keyword) { create(:keyword) }

  subject { page }


  describe 'edit' do

    before do
      admin_login
      visit keyword_path(keyword)
      click_on 'Edit Keyword'
    end

    it 'displays title' do expect(subject).to have_selector('h1', 'Edit Keyword') end

    context 'making changes' do

      before do
        admin_login
        visit keyword_path(keyword)
        click_on 'Edit Keyword'
        fill_in('Name', with: 'new keyword')
        click_on 'submit'
      end

      it 'flashes success' do expect(subject).to have_content('Update Successful') end
      it 'changes name' do expect(subject).to have_content('new keyword') end

    end
  end

  describe 'new' do

    before do
      admin_login
      visit keywords_path
      click_on 'New Keyword'
      fill_in('Name', with: 'newer keyword')
      click_on 'submit'
    end

      it 'flashes success' do expect(subject).to have_content('Keyword Created') end
      it 'lists in index' do expect(subject).to have_content('newer keyword') end

  end

  describe 'delete' do

    before do
      admin_login
      visit keyword_path(keyword)
      click_on "Delete"
    end

    it 'flashes success' do expect(subject).to have_content('Delete Successful!') end
    it 'removes from index' do expect(subject).to_not have_content(keyword.name) end

  end
end