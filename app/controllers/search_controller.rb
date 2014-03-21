class SearchController < ApplicationController
  
  def search
    if params[:search] == ""
      redirect_to root_path
      flash[:error] = "Please enter a search term."
    else
      @authors = Author.search(params[:search])
      @books = Book.search(params[:search])
    end
  end

end
