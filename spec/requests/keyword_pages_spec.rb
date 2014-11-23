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

  describe "edit" do

    context "as admin" do
      before do
        admin_login
        visit edit_keyword_path(keyword)
      end

      it "has name field" do expect(subject).to have_field("Name") end
      it "has delete link" do expect(subject).to have_button("Submit") end
    end

    context "as librarian" do
      before do
        librarian_login
        visit edit_keyword_path(keyword)
      end

      it "has name field" do expect(subject).to have_field("Name") end
      it "has delete link" do expect(subject).to have_button("Submit") end
    end

  end

  describe "show" do

    context "as guest/patron" do

      before { visit keyword_path(keyword.id) }

      it "keyword as h2" do expect(subject).to have_selector('h2', text: keyword.name) end
      it "books" do expect(subject).to have_content(book.title) end
      it "genre" do expect(subject).to have_content(genre.name) end
      it "author" do expect(subject).to have_content(author.name) end
    end

    context "as admin" do
      before do
        admin_login
        visit keywords_path
      end

      it "has edit link" do expect(subject).to have_link("Edit") end
      it "has delete link" do expect(subject).to have_link("Delete") end
    end


    context "as librarian" do
      before do
        librarian_login
        visit keywords_path
      end

      it "has edit link" do expect(subject).to have_link("Edit") end
      it "has delete link" do expect(subject).to have_link("Delete") end
    end

  end

  describe "index" do

    context "as guest/patron" do
      
      before { visit keywords_path }

      it "has link to keyword" do expect(subject).to have_link(keyword.name, keyword_path(keyword.id)) end
    end

    context "as admin" do
      before do
        admin_login
        visit keywords_path
      end

      it "has edit link" do expect(subject).to have_link("Edit") end
      it "has delete link" do expect(subject).to have_link("Delete") end
    end


    context "as librarian" do
      before do
        librarian_login
        visit keywords_path
      end

      it "has edit link" do expect(subject).to have_link("Edit") end
      it "has delete link" do expect(subject).to have_link("Delete") end
    end
  end

end