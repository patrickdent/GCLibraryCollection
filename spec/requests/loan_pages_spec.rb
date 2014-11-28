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
  end 
end