require 'spec_helper'

describe 'Static Pages', type: feature do 
  subject { page }

  describe 'Home Page' do 
    before { visit root_path }

    it { should have_link('Browse by Genre', href: genres_path) }
    it { should have_link('Browse by Author', href: authors_path) }
      
      describe 'Search Form' do
        
        describe 'clicking on search with an empty search field' do
          before { click_on 'Search' }
          it { should have_content('Please enter a search term.') }
        end

        describe 'searching for something that\'s not in the database' do
          before do 
            fill_in('search', :with => 'XXXXXXXXXXXX!XXX')
            click_on('Search')
          end
          it { should have_content('Your search yeilded no results.') } 
        end

        describe 'searching for something that\'s in the database' do
          before do 
            fill_in('search', :with => 'Test Book')
            click_on('Search')
          end
          it { should have_content('Test Book 1') }
        end 
      end

    describe 'links should work' do
      before { click_on 'Browse by Genre' }
      it {should have_content 'Meowstory' }
    end
  end 

  describe ''
end 
