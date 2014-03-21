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

   it { should have_link(genre.name, genre_path(genre.id)) }

  end

  describe "show" do

   before { visit genre_path(genre.id) }

   it { should have_selector('h1', text: genre.name) }
   it { should have_content(book.title) }
   it { should have_content(book.authors.first.name) }

  end
end