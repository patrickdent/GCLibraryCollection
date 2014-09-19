# spec/controllers/search_controller_spec.rb
require 'spec_helper' 

describe SearchController do

  describe '#search' do 

    it 'returns results for good search terms' do 
      keyword = FactoryGirl.create(:keyword)
      get :search, "search" => "keyword"
      response.should be_ok
      expect(assigns[:keywords]).to include(keyword)
    end 

    it 'returns results for good, multi-word search terms' do 
      book = FactoryGirl.create(:book, title: "The True Story of Those Boots")
      get :search, "search" => "True Boots"
      response.should be_ok
      expect(assigns[:books]).to include(book)
    end 

    it 'returns nothing for unsuccessful searches' do 
      get :search, search: "Pegasus"
      response.should be_ok
      expect(assigns[:authors].empty?).to be_true
    end 

    it 'redirects with notice for nil search terms' do 
      get :search, search: ""
      flash[:notice].should_not be_nil
      response.should redirect_to root_url
    end 

  end 
end 