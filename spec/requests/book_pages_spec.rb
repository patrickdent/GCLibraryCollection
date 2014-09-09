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

  describe "show" do

    before { visit book_path(book.id) }

    it "title" do expect(subject).to have_selector('h1', text: book.title) end
    it "author" do expect(subject).to have_content(author.name) end
    it "genre" do expect(subject).to have_content(genre.name) end
    it "keyword" do expect(subject).to have_content(keyword.keyword) end
    it "no edit" do expect(subject).to_not have_content("Edit") end
    
    #not all books have ISBNs, so not testing for presence 

  end
end