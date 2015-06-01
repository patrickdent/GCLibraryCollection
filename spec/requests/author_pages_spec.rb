require 'spec_helper'

describe "Author Pages" do
  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    BookAuthor.create(book: book, author: author)
    BookAuthor.create(book: book2, author: author)
  end
  after do
    DatabaseCleaner.clean
  end

  after :each do
    Warden.test_reset!
  end

  let(:genre)   { create(:genre, name: "a genre") }
  let(:genre2)  { create(:genre, name: "z genre") }
  let(:author)  { create(:author) }
  let(:book)    { create(:book, title: "a book", genre: genre) }
  let(:book2)   { create(:book, title: "z book", genre: genre2, available: false) }


  subject { page }

  describe "index" do

   before { visit authors_path }

   it { should have_link(author.display_name, author_path(author.id)) }

  end

  describe "show" do

    before do
      visit author_path(author.id)
    end

    it "has author name" do expect(subject).to have_selector('h2', text: author.name) end
    it "has book title" do expect(subject).to have_content(book.title) end
    it "has book genre" do expect(subject).to have_content(book.genre.name) end

    it "has sort links" do
      expect(page).to have_link("Title", href: author_path(author.id).to_s + "?direction=asc&sort=title")
      expect(page).to have_link("Category", href: author_path(author.id).to_s + "?direction=asc&sort=cat_name")
      expect(page).to have_link("Available", href: author_path(author.id).to_s + "?direction=asc&sort=available")
    end

    context "with table sorted by title" do
      it "orders them (asc)" do
        visit author_path(author.id).to_s + "?direction=asc&sort=title"
      #note: if the order of the columns in table changes, the "(1)" will need to change to reflect new postion of title
        expect(page.find("tbody tr:nth-child(1) td:nth-child(1)")).to have_content(book.title)
        expect(page.find("tbody tr:nth-child(2) td:nth-child(1)")).to have_content(book2.title)
      end

      it "orders them (desc)" do
        visit author_path(author.id).to_s + "?direction=desc&sort=title"
      #note: if the order of the columns in table changes, the "(1)" will need to change to reflect new postion of title
        expect(page.find("tbody tr:nth-child(2) td:nth-child(1)")).to have_content(book.title)
        expect(page.find("tbody tr:nth-child(1) td:nth-child(1)")).to have_content(book2.title)
      end
    end

    context "with table sorted by category" do
      it "orders them (asc)" do
        visit author_path(author.id).to_s + "?direction=asc&sort=cat_name"
      #note: if the order of the columns in table changes, the "(1)" will need to change to reflect new postion of title
        expect(page.find("tbody tr:nth-child(1) td:nth-child(1)")).to have_content(book.title)
        expect(page.find("tbody tr:nth-child(2) td:nth-child(1)")).to have_content(book2.title)
      end

      it "orders them (desc)" do
        visit author_path(author.id).to_s + "?direction=desc&sort=cat_name"
      #note: if the order of the columns in table changes, the "(1)" will need to change to reflect new postion of title
        expect(page.find("tbody tr:nth-child(2) td:nth-child(1)")).to have_content(book.title)
        expect(page.find("tbody tr:nth-child(1) td:nth-child(1)")).to have_content(book2.title)
      end
    end

    context "with table sorted by availability" do
      it "orders them (asc)" do
        visit author_path(author.id).to_s + "?direction=asc&sort=available"
      #note: if the order of the columns in table changes, the "(1)" will need to change to reflect new postion of title
        expect(page.find("tbody tr:nth-child(1) td:nth-child(1)")).to have_content(book.title)
        expect(page.find("tbody tr:nth-child(2) td:nth-child(1)")).to have_content(book2.title)
      end

      it "orders them (desc)" do
        visit author_path(author.id).to_s + "?direction=desc&sort=available"
      #note: if the order of the columns in table changes, the "(1)" will need to change to reflect new postion of title
        expect(page.find("tbody tr:nth-child(2) td:nth-child(1)")).to have_content(book.title)
        expect(page.find("tbody tr:nth-child(1) td:nth-child(1)")).to have_content(book2.title)
      end
    end
  end
end