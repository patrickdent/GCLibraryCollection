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
      it "doesn't display return date" do expect(page).to_not have_content('Returned:') end
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

  describe 'form' do
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
end