require 'spec_helper'

describe "Keyword Pages" do

  let(:genre)   { create(:genre)}
  let(:book)    { create(:book, genre: genre) }
  let(:author)  { create(:author) }
  let(:keyword) { create(:keyword) }


  before do
   book.keywords << keyword
   book.genre = genre
   book.authors << author
  end

  subject { page }

  describe "show" do

    before { visit keyword_path(keyword.id) }

    it "keyword as h2" do expect(subject).to have_selector('h2', text: keyword.name) end
    it "books" do expect(subject).to have_content(book.title) end
    it "genre" do expect(subject).to have_content(genre.name) end
    it "author" do expect(subject).to have_content(author.name) end
    #maybe authors associated with keyword

  end

  describe "index" do

   before { visit keywords_path }

   it "has link to keyword" do expect(subject).to have_link(keyword.name, keyword_path(keyword.id)) end

  end

end