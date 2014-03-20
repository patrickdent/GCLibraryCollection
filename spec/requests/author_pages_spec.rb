require 'spec_helper'



#before running test:
#run: rake RAILS_ENV=test db:seed

describe "Author Pages" do

  let(:author)  { create(:author) }
  let(:book)    { create(:book) }

  # problamatic...not sure why
  # let(:genre)   { FactoryGirl.create(:genre) }
  # let(:genre)   { Genre.first }
  

  before do
   # problamatic...not sure why 
   # book.genre_id = genre.id
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