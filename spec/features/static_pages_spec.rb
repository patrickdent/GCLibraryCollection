require 'spec_helper'

describe 'Static Pages', type: feature do 
  subject { page }

  describe 'Home Page' do 
    before { visit root_path }

    it 'has working genre link' do expect(subject).to have_link('Browse by Genre', href: genres_path) end
    it 'has working author link' do expect(subject).to have_link('Browse by Author', href: authors_path) end
    it 'does not have admin links' do expect(subject).to_not have_link('Admin Dashboard') end
    it 'does not have logout links' do expect(subject).to_not have_link('Logout') end
    it 'does not have profile links' do expect(subject).to_not have_link('Edit profile') end

    describe 'Search' do

      context 'with no term' do
        before { click_on 'Search' }
        it 'promts for term' do expect(subject).to have_content('Please enter a search term.') end
      end

      context 'with non-matching term' do
        before do 
          fill_in('search', :with => 'XXXXXXXXXXXX!XXX')
          click_on('Search')
        end
        it 'flashes no results' do expect(subject).to have_content('Your search yielded no results.') end
      end

      context 'with matching term' do
        before do 
          @book = FactoryGirl.create(:book)
          fill_in('search', :with => @book.title)
          click_on('Search')
        end
        it 'shows matches' do expect(subject).to have_content("Books #{@book.title}") end
      end 
    end
  end

  describe 'Admin' do
    
    describe 'login' do

      context 'with invalid credentials' do
        before do
          visit root_path
          click_on('Login')
          fill_in("Email", :with => 'bogus@email.com')
          fill_in("Password", :with => 'nope')
          click_on("Sign in")
        end

        it "should flash invalid" do expect(subject).to have_content('Invalid email or password.') end
      end


      context 'valid credentials' do
        before do
          admin_login
        end

        it "should flash success" do expect(subject).to have_content('Signed in successfully.') end
        it 'has admin links' do expect(subject).to have_link('Admin Dashboard') end
        it 'has logout links' do expect(subject).to have_link('Logout') end
        it 'has profile links' do expect(subject).to have_link('Edit profile') end
      end

      context 'logout' do
        before do
          admin_login
          click_on 'Logout'
        end

        it "should flash success" do expect(subject).to have_content('Signed out successfully.') end
        it 'does not have admin links' do expect(subject).to_not have_link('Admin Dashboard') end
        it 'does not have logout links' do expect(subject).to_not have_link('Logout') end
        it 'does not have profile links' do expect(subject).to_not have_link('Edit profile') end
      end
    end

    describe 'Dashboard' do
      before do
          admin_login
          click_on('Admin Dashboard')
      end

      describe 'links' do
        it 'has upload' do expect(subject).to have_link('Upload Books') end
        it 'has broswe all' do expect(subject).to have_link('Manage Books') end
        it 'has manage genres' do expect(subject).to have_link('Manage Genres') end
      end
    end
  end

end 
