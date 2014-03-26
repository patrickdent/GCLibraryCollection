require 'spec_helper'

describe "Book Pages" do

  let(:genre)   { create(:genre)}
  let(:book)    { create(:book, genre: genre) }
  let(:author)  { create(:author) }
  

  before do
   author.books << book
  end

  subject { page }

  describe "show" do

    before { visit book_path(book.id) }

    it { should have_selector('h1', text: book.title) }
    it { should have_content(book.authors.first.name) }
    it { should have_content(book.genre.name) }
    #not all books have ISBNs, so not testing for presence 

  end
end