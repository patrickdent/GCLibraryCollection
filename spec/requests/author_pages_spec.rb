require 'spec_helper'

describe "Author Pages" do
  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    BookAuthor.create(book: book, author: author)
  end
  after do
    DatabaseCleaner.clean
  end

  let(:genre)   { create(:genre)}
  let(:book)    { create(:book, genre: genre) }
  let(:author)  { create(:author) }

  subject { page }

  describe "index" do

   before { visit authors_path }

   it { should have_link(author.name, author_path(author.id)) }

  end

  describe "show" do

    before do
      visit author_path(author.id)
      # save_and_open_page
    end

   it { should have_selector('h2', text: author.name) }
   it { should have_content(book.title) }
   it { should have_content(book.genre.name) }

  end
end