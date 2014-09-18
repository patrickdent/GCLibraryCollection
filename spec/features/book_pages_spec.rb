require 'spec_helper'

describe 'Book Pages', type: feature do
  
  let(:book) { FactoryGirl.create(:book) }

  subject { page }


  describe 'show' do

    before do
      visit book_path(book)
    end

    it 'displays title' do expect(subject).to have_content(book.title) end
    it 'displays author' do expect(subject).to have_content(book.author) end 


  end
  
end