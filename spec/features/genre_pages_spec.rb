require 'spec_helper'

describe 'Genre Pages', type: feature do
  
  let(:genre) { create(:genre) }

  subject { page }


  describe 'edit' do

    before do
      admin_login
      visit genre_path(genre)
      click_on 'Edit Genre'
    end

    it 'displays title' do expect(subject).to have_selector('h1', 'Edit Genre') end
    
    context 'making changes' do

      before do
        admin_login
        visit genre_path(genre)
        click_on 'Edit Genre'
        fill_in('Name', with: 'new genre')
        click_on 'Submit'
      end

      it 'flashes success' do expect(subject).to have_content('Update Successful') end
      it 'changes name' do expect(subject).to have_content('new genre') end

    end
  end
  
  describe 'new' do

    before do 
      admin_login
      visit genres_path
      click_on 'New Genre'
      fill_in('Name', with: 'newer genre')
      fill_in('Abbreviation', with: 'NG')
      click_on 'Submit'
    end

      it 'flashes success' do expect(subject).to have_content('Genre added') end
      it 'lists in index' do expect(subject).to have_content('newer genre') end

  end

  describe 'delete' do

    before do 
      admin_login
      visit genre_path(genre)
      click_on "Delete"
    end

    it 'flashes success' do expect(subject).to have_content('Delete Successful!') end
    it 'removes from index' do expect(subject).to_not have_content(genre.name) end

  end
end