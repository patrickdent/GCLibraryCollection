require 'spec_helper'

describe "Loan Pages" do
  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after do
    DatabaseCleaner.clean
  end

  after :each do
    Warden.test_reset!
  end

  let(:user)   { create(:user, name: "a user", phone: "123456789")}
  let(:user2)   { create(:user, name: "z user", phone: "987654321")}
  let(:book)    { create(:book, title: "a book") }
  let(:book2)    { create(:book, title: "z book") }

  subject { page }

  describe 'index' do
    before do
      librarian_login
      @loan = create(:loan, user_id: user.id, book_id: book.id)
      visit loans_path
    end

    it "links to loans" do expect(page).to have_link('view', loan_path(@loan.id)) end
    it "links to user" do expect(page).to have_link(user.name, user_path(user.id)) end
    it "links to book" do expect(page).to have_link(book.title, book_path(book.id)) end
    it "displays start date" do expect(page).to have_content(@loan.start_date) end
    it "displays due date" do expect(page).to have_content(@loan.due_date) end
    it "displays return date" do expect(page).to have_content(@loan.returned_date) end
    it "displays renewals" do expect(page).to have_content(@loan.renewal_count) end
  end

  describe 'show' do

    context 'active loan' do
      before do
        librarian_login
        @loan = create(:loan, user_id: user.id, book_id: book.id)
        visit loan_path(@loan.id)
      end

      it "links to user" do expect(page).to have_link(user.name, user_path(user.id)) end
      it "links to book" do expect(page).to have_link(book.title, book_path(book.id)) end
      it "displays start date" do expect(page).to have_content(@loan.start_date) end
      it "displays due date" do expect(page).to have_content(@loan.due_date) end
      it "displays renewals" do expect(page).to have_content(@loan.renewal_count) end
    end

    context 'returned loan' do
      before do
        librarian_login
        @loan = create(:loan, user_id: user.id, book_id: book.id)
        @loan.return_loan
        visit loan_path(@loan.id)
      end

      it "displays return date" do expect(page).to have_content(@loan.returned_date) end
    end
  end

  describe 'loan_list' do
    context 'on user#show' do
      before do
        librarian_login
        @loan = create(:loan, user_id: user.id, book_id: book.id)
        visit user_path(user.id)
      end

      it "shows loan title" do expect(page).to have_link(book.title) end
      it "displays start date" do expect(page).to have_content(@loan.start_date) end
      it "displays due date" do expect(page).to have_content(@loan.due_date) end
      it "displays renewals" do expect(page).to have_content(@loan.renewal_count) end
    end

    context 'on book#show' do
      before do
        librarian_login
        @loan = create(:loan, user_id: user.id, book_id: book.id)
        visit book_path(book.id)
      end

      it "shows loan title" do expect(page).to have_link(user.name) end
      it "displays start date" do expect(page).to have_content(@loan.start_date.to_s) end
      it "displays due date" do expect(page).to have_content(@loan.due_date.to_s) end
      it "displays renewals" do expect(page).to have_content(@loan.renewal_count) end
    end
  end

  describe 'overdue list' do
    before do
      librarian_login
      @later_loan = create(:loan, user_id: user.id, book_id: book.id, due_date: "2015-04-10", start_date: "2015-03-10")
      @earlier_loan = create(:loan, user_id: user2.id, book_id: book2.id, due_date: "2015-04-01", start_date: "2015-03-01")
      visit overdue_list_path
    end

    it "shows all overdue loans" do
     expect(page).to have_content(@later_loan.due_date.to_s)
     expect(page).to have_content(@earlier_loan.due_date.to_s)
   end

    it "shows them in order by start date (desc)" do
      #note: if the order of the columns in table changes, the "(3)" will need to change to reflect new postion of start date
      expect(page.find("tbody tr:nth-child(2) td:nth-child(3)")).to have_content(@earlier_loan.start_date.to_s)
      expect(page.find("tbody tr:nth-child(1) td:nth-child(3)")).to have_content(@later_loan.start_date.to_s)
    end

    it "has sort links" do
      expect(page).to have_link("Book Title", href: overdue_list_path.to_s + "?direction=asc&sort=title")
      expect(page).to have_link("User", href: overdue_list_path.to_s + "?direction=asc&sort=name")
      expect(page).to have_link("Start Date", href: overdue_list_path.to_s + "?direction=asc&sort=start_date")
      expect(page).to have_link("Due Date", href: overdue_list_path.to_s + "?direction=asc&sort=due_date")
      expect(page).to have_link("Borrower Name", href: overdue_list_path.to_s + "?direction=asc&sort=name")
      expect(page).to have_link("Borrower Phone", href: overdue_list_path.to_s + "?direction=asc&sort=phone")
    end

    context "with table sorted by title" do
      before { visit overdue_list_path.to_s + "?direction=asc&sort=title" }

      it "orders them by default (asc)" do
      #note: if the order of the columns in table changes, the "(1)" will need to change to reflect new postion of title
        expect(page.find("tbody tr:nth-child(1) td:nth-child(1)")).to have_content(book.title)
        expect(page.find("tbody tr:nth-child(2) td:nth-child(1)")).to have_content(book2.title)
      end
    end

    context "with table sorted by user" do
      before { visit overdue_list_path.to_s + "?direction=asc&sort=name" }

      it "orders them by default (asc)" do
      #note: if the order of the columns in table changes, the "(2)" will need to change to reflect new postion of title
        expect(page.find("tbody tr:nth-child(1) td:nth-child(2)")).to have_content(user.name)
        expect(page.find("tbody tr:nth-child(2) td:nth-child(2)")).to have_content(user2.name)
      end
    end

    context "with table sorted by due date" do
      before { visit overdue_list_path.to_s + "?direction=asc&sort=due_date" }

      it "orders them by default (asc)" do
      #note: if the order of the columns in table changes, the "(4)" will need to change to reflect new postion of title
        expect(page.find("tbody tr:nth-child(1) td:nth-child(4)")).to have_content(@earlier_loan.due_date)
        expect(page.find("tbody tr:nth-child(2) td:nth-child(4)")).to have_content(@later_loan.due_date)
      end
    end

    context "with table sorted by borrower name" do
      before { visit overdue_list_path.to_s + "?direction=asc&sort=name" }

      it "orders them by default (asc)" do
      #note: if the order of the columns in table changes, the "(5)" will need to change to reflect new postion of title
        expect(page.find("tbody tr:nth-child(1) td:nth-child(5)")).to have_content(user.name)
        expect(page.find("tbody tr:nth-child(2) td:nth-child(5)")).to have_content(user2.name)
      end
    end

    context "with table sorted by phone" do
      before { visit overdue_list_path.to_s + "?direction=asc&sort=phone" }

      it "orders them by default (asc)" do
      #note: if the order of the columns in table changes, the "(6)" will need to change to reflect new postion of title
        expect(page.find("tbody tr:nth-child(1) td:nth-child(6)")).to have_content(user.phone)
        expect(page.find("tbody tr:nth-child(2) td:nth-child(6)")).to have_content(user2.phone)
      end
    end
  end
end