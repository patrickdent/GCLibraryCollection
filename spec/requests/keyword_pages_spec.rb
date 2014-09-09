require 'spec_helper'

describe "Keyword Pages" do

  let(:genre)   { create(:genre)}
  let(:book)    { create(:book, genre: genre) }
  let(:author)  { create(:author) }
  let(:keyword) { create(:keyword) }


  before do
   book.keywords << keyword
  end

  subject { page }

  describe "index" do

   before { visit keywords_path }

   it "has link to keyword" do expect(subject).to have_link(keyword.keyword, keyword_path(keyword.id)) end

  end

  describe "show" do

    before { visit keyword_path(keyword.id) }

    it "keyword as h1" do expect(subject).to have_selector('h1', text: keyword.keyword) end
    it "books" do expect(subject).to have_content(book.title) end
    it "genre" do expect(subject).to have_content(book.genre.name) end
    #maybe authors associated with keyword

  end

end