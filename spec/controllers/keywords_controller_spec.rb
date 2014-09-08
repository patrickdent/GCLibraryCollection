require 'spec_helper'

describe KeywordsController do

  before do 
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    @keyword = create :keyword 
    @user = create :user
    @admin = create :admin 
  end 

  after do 
    DatabaseCleaner.clean
  end 

  after :each do 
    Warden.test_reset! 
  end 

  describe "GET 'index'" do 
    it "shows all keywords" do 
      get :index 

      expect(assigns[:keyword]).to include @keyword
    end 

  end 

  describe "GET 'show'" do 
    it "shows the specified keyword" do 
      get :show, id: @keyword.id 

      expect(assigns[:keyword]).to eq @keyword 
    end 
  end

end