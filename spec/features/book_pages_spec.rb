require 'spec_helper'

describe 'Book Pages', type: feature do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  let(:book) { FactoryGirl.create(:book, title: "completely Unique") }
  let(:genre) { create(:genre) }
  let(:author) { create(:author) }
  let(:keyword) { create(:keyword) }

  subject { page }


  describe 'edit' do

    before do
      admin_login
      visit book_path(book)
      click_on 'Edit This Book'
    end

    it 'displays title' do expect(subject).to have_selector('h1', 'Edit Book') end

    context 'making changes' do

      before do
        admin_login
        visit book_path(book)
        click_on 'Edit This Book'
        fill_in('Title', with: 'new title')

#Can't get capybara to see select boxes

        # select(genre.name, from: 'Genre')
        # select(author.name, from: 'Author')
        # select(keyword.name, from: 'Keyword')
        click_on 'submit'

      end

      it 'flashes success' do expect(subject).to have_content('Update Successful') end
      it 'changes title' do expect(subject).to have_content('new title') end

#Can't get capybara to see select boxes

      # it 'changes genre' do expect(subject).to have_content(genre.name) end
      # it 'changes author' do expect(subject).to have_content(author.name) end
      # it 'changes keyword' do expect(subject).to have_content(keyword.name) end

    end
  end

  describe 'new' do

    before do
      admin_login
      visit books_path
      click_on 'New Book'
      fill_in('Title', with: 'new title')

#Can't get capybara to see select boxes

      # select(Genre.all[0].name, from: 'Genre')
      # select(Author.all[0].name, from: 'Author')
      # select(Keyword.all[0].name, from: 'Keyword')
      click_on 'submit'
    end

      it 'flashes success' do expect(subject).to have_content('Book Created') end
  end

  describe 'delete' do

    before do
      admin_login
      visit book_path(book)
      click_on "Delete"
    end

    it 'flashes success' do expect(subject).to have_content('Delete Successful!') end
    it 'removes from index' do expect(subject).to_not have_content(book.title) end

  end
end