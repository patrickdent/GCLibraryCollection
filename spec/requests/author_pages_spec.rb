require 'spec_helper'



#before running test:
#run: rake RAILS_ENV=test db:seed

describe "Author Pages" do

  let(:genre)   { create(:genre)}
  let(:book)    { create(:book, genre: genre) }
  let(:author)  { create(:author) }
  

  before do
   author.books << book
  end

  subject { page }

  describe "index" do

   before { visit authors_path }

   it { should have_link(author.name, author_path(author.id)) }

  end

  describe "show" do

   before { visit author_path(author.id) }

   it { should have_selector('h1', text: author.name) }
   it { should have_content(book.title) }
   it { should have_content(book.genre.name) }

  end
end