class SearchController < ApplicationController
  
  def search
    if params[:search] == ""
      redirect_to root_path
      flash[:notice] = "Please enter a search term."
    else
      @authors = Author.search(params[:search])
      @books = Book.search(params[:search])
      @genres = Genre.search(params[:search])
    end
  end

end
