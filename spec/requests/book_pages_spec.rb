require 'spec_helper'

describe "Book Pages" do

  let(:genre)   { create(:genre)}
  let(:book)    { create(:book, genre: genre) }
  let(:author)  { create(:author) }
  let(:keyword) { create(:keyword) }
  

  before do
   author.books << book
   book.keywords << keyword
  end

  subject { page }

  describe 'index' do
    context "as non-admin" do
      before { visit books_path }

      it "links to books" do expect(subject).to have_link(book.title) end
      it "links to author" do expect(subject).to have_link(book.authors.first.name) end
      it "links to genre" do expect(subject).to have_link(book.genre.name) end
    end

    context "as admin" do
      before do
        admin_login
        visit book_path(book)
      end

      it 'edit' do expect(subject).to have_link("edit") end
      it 'delete' do expect(subject).to have_link("delete") end
    end
  end

  describe "show" do

    context "as non-admin" do
      before { visit book_path(book) }

      it "title" do expect(subject).to have_selector('h2', text: book.title) end
      it "author" do expect(subject).to have_link(author.name) end
      it "genre" do expect(subject).to have_link(genre.name) end
      it "keyword" do expect(subject).to have_link(keyword.name) end
      it "no edit" do expect(subject).to_not have_content("edit") end
      #not all books have ISBNs, so not testing for presence 
    end

    context "as admin" do
      before do
        admin_login
        visit book_path(book)
      end

      it 'edit' do expect(subject).to have_link("edit") end
      it 'delete' do expect(subject).to have_link("delete") end
    end
  end
end