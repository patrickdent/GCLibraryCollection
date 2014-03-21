class SearchController < ApplicationController
  
  def search
    @authors = Author.search(params[:search])
  end

end
