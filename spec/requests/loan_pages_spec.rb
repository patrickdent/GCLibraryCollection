require 'spec_helper'

describe "Loan Pages" do

  let(:user)   { create(:user)}
  let(:book)    { create(:book) }

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
      book.update_attributes(count: 2)
      @later_loan = create(:loan, user_id: user.id, book_id: book.id, due_date: "2015-04-10", start_date: "2015-03-10")
      @earlier_loan = create(:loan, user_id: user.id, book_id: book.id, due_date: "2015-04-01", start_date: "2015-03-01")
      visit overdue_list_path
    end

    it "shows all overdue loans" do
     expect(page).to have_content(@later_loan.due_date.to_s)
     expect(page).to have_content(@earlier_loan.due_date.to_s)
   end

    it "shows them in order by start date" do
      #note: if the order of the columns in table changes, the "(3)" will need to change to reflect new postion of start date
      expect(page.find("tbody tr:nth-child(1) td:nth-child(3)")).to have_content(@earlier_loan.start_date.to_s)
      expect(page.find("tbody tr:nth-child(2) td:nth-child(3)")).to have_content(@later_loan.start_date.to_s)
    end
  end
end