require 'spec_helper'
require 'support/api_utilities'

describe 'Search Pages', type: feature do

  let(:author) { create(:author) }
  let(:book) { create(:book) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:isbn) { "123456-7890" }

  subject { page }

  describe "search" do
    before { visit root_path }

    it "displays flash for no result" do
      fill_in('search', with: 'qxys')
      click_on('search')
      expect(subject).to have_content('Your search yielded no results.')
    end

    it 'displays a flash for no terms' do
      click_on('search')
      expect(subject).to have_content('Please enter a search term.')
    end

    it 'displays results for good terms' do
      fill_in('search', with: book.title)
      click_on('search')
      expect(subject).to have_content(book.title)
    end
  end
end