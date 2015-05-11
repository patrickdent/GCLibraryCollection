require 'spec_helper'

describe "Book Pages" do
  let(:genre)   { create(:genre)}
  let(:book)    { create(:book, genre: genre) }
  let(:author)  { create(:author) }
  let(:keyword) { create(:keyword) }

  subject { page }

  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    BookAuthor.create(book: book, author: author)
    BookKeyword.create(book: book, keyword: keyword)
  end
  after do
    DatabaseCleaner.clean
  end

  after :each do
    Warden.test_reset!
  end

  describe 'index' do
    context "as non-admin" do
      before { visit books_path }

      it "links to books" do expect(subject).to have_link(book.title) end
      it "links to author" do expect(subject).to have_link(book.authors.first.display_name) end
      it "links to genre" do expect(subject).to have_link(book.genre.name) end
    end

    context "as admin" do
      before do
        admin_login
        visit book_path(book)
      end

      it 'edit' do expect(subject).to have_link("Edit") end
      it 'delete' do expect(subject).to have_link("Delete") end
    end
  end

  describe "show" do

    context "as non-admin" do
      before { visit book_path(book) }

      it "title" do expect(subject).to have_selector('h2', text: book.title) end
      it "author" do expect(subject).to have_link(author.display_name) end
      it "genre" do expect(subject).to have_link(genre.name) end
      it "keyword" do expect(subject).to have_link(keyword.name) end
      it "no edit" do expect(subject).to_not have_content("Edit") end
      #not all books have ISBNs, so not testing for presence
    end

    context "as admin" do
      before do
        book.update_attributes(count: 2)
        book.reload
        admin_login
        visit book_path(book)
      end

      it 'edit' do expect(subject).to have_link("Edit") end
      it 'delete' do expect(subject).to have_link("Delete") end
      it 'remove one' do expect(subject).to have_button("Remove Copy") end
    end
  end
end