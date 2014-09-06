require 'spec_helper'

describe 'Static Pages', type: feature do 
  subject { page }

  describe 'Home Page' do 
    before { visit root_path }

    # it { should have_link('Browse by Genre', href: genres_path) }
    it 'has working genre link' do expect(subject).to have_link('Browse by Genre', href: genres_path) end
    # it { should have_link('Browse by Author', href: authors_path) }
    it 'has working author link' do expect(subject).to have_link('Browse by Author', href: authors_path) end
          
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
        it 'flashes no results' do expect(subject).to have_content('Your search yeilded no results.') end
      end

      context 'with matching term' do
        before do 
          fill_in('search', :with => 'Test Book')
          click_on('Search')
        end
        it 'shows matches' do expect(subject).to have_content('Test Book 1') end
      end 
    end
  end

  describe 'Admin Dashboard' do
    
    describe 'login' do
      before do
        visit root_path
        click_on('Login')
      end

      context 'with invalid credentials' do
        before do
          fill_in("Email", :with => 'bogus@email.com')
          fill_in("Password", :with => 'nope')
          click_on("Sign in")
        end

        it "should flash invalid" do expect(subject).to have_content('Invalid email or password.') end
      end


      context 'valid credentials' do
        before do
          fill_in("Email", :with => 'admin@example.com')
          fill_in("Password", :with => 'password')
          click_on("Sign in")
        end

        it "should flash success" do expect(subject).to have_content('Signed in successfully.') end
      end
    end
  end
end 
