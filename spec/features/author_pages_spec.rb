require 'spec_helper'

describe 'Author Pages', type: feature do
  
  let(:author) { create(:author) }

  subject { page }


  describe 'edit' do

    before do
      admin_login
      visit author_path(author)
      click_on 'Edit Author'
    end

    it 'displays title' do expect(subject).to have_selector('h1', 'Edit Author') end
    
    context 'making changes' do

      before do
        admin_login
        visit author_path(author)
        click_on 'Edit Author'
        fill_in('Name', with: 'new author')
        click_on 'Submit'
      end

      it 'flashes success' do expect(subject).to have_content('Update Successful') end
      it 'changes name' do expect(subject).to have_content('new author') end

    end
  end
  
  describe 'new' do

    before do 
      admin_login
      visit authors_path
      click_on 'New Author'
      fill_in('Name', with: 'newer author')
      click_on 'Submit'
    end

      it 'flashes success' do expect(subject).to have_content('Author Created') end
      it 'lists in index' do expect(subject).to have_content('newer author') end

  end

  describe 'delete' do

    before do 
      admin_login
      visit author_path(author)
      click_on "Delete"
    end

    it 'flashes success' do expect(subject).to have_content('Delete Successful!') end
    it 'removes from index' do expect(subject).to_not have_content(author.name) end

  end
end