require 'spec_helper'

describe "Genre Pages" do

  let(:genre)   { create(:genre)}
  let(:book)    { create(:book, genre: genre) }
  let(:author)  { create(:author) }

  before do
   author.books << book
  end

  subject { page }

  describe "index" do

   before { visit genres_path }

   it "has links to genres" do expect(subject).to have_link(genre.name, genre_path(genre.id)) end

  end

  describe "show" do

   before { visit genre_path(genre.id) }

   it 'has genre title' do expect(subject).to have_selector('h1', text: genre.name) end
   it 'has book title' do expect(subject).to have_content(book.title) end
   it 'has authors' do expect(subject).to have_content(book.authors.first.name) end
   it 'has abbreviation' do expect(subject).to have_content(genre.abbreviation) end

    context 'with no abbreviation' do
      before do
        @genre = FactoryGirl.create(:genre, name: "gobbldygook", abbreviation: nil)
        visit genre_path(@genre.id)
      end

      it "doesn't display the bar" do expect(subject).to_not have_selector('h1', text: "|") end
    end
  end
end