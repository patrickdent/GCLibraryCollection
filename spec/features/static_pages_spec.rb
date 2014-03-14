require 'spec_helper'

describe 'Static Pages', type: feature do 
  subject { page }

  describe 'Home Page' do 
    before { visit root_path }

    it { should have_link('Browse by Genre', href: genres_path) }
    it { should have_link('Browse by Author', href: authors_path) }
  end 
end 
