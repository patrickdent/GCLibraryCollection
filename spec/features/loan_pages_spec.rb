require 'spec_helper'

describe 'Loan Pages', type: feature do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  subject { page }
  let! ( :user ) { create :user }
  let! ( :loaned_book ) { create :book }
  let! ( :available_book ) {create :book}
  let! ( :loan ) { create :loan, user_id: user.id, book_id: loaned_book.id }

  describe 'checking out' do
    before do
      librarian_login
      visit book_path(available_book)
    end

    it 'creates a loan if everything is cool' do
      pending('Waiting for selenium to get upgraded so we can run js:true tests :(')
      expect(subject).to have_content('Loan Book')
      click_on('Loan Book')
      expect(subject).to have_content('User')

      select(user.name, from: 'loan_user_id')
      click_on('Submit')
      # expect loan count to have changed
      expect(subject).to have_content('Loan Created')
    end

    # it 'does not create a loan if user is not good to borrow' do

    # end

    # it 'does not create a loan if book is not available' do

    # end

  end

  # describe 'checking in' do
  #   before do
  #     admin_login
  #     visit reports_path
  #   end

  #   it '' do
  #   end

  # end

  # describe 'renew' do
  #   before do
  #     admin_login
  #     visit reports_path
  #   end

  #   it '' do
  #   end

  # end

  # describe 'viewing overdue' do
  #   before do
  #     admin_login
  #     visit reports_path
  #   end

  #   it 'displays them all' do
  #   end

  #   it 'sends overdue notices' do

  #   end

  # end


end