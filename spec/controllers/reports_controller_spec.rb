require 'spec_helper'

describe ReportsController do

  describe "dashboard" do

    it "returns some books" do
      get :dashboard
      expect(assigns(:books)).to_not eq(nil)
    end

  end

end