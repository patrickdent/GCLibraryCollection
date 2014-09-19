class SearchController < ApplicationController
  
  def search
    if params[:search] == ""
      flash[:notice] = "Please enter a search term."
      redirect_to root_path
      return 
    else
      @authors = Author.search(params[:search])
      @books = Book.search(params[:search])
      @genres = Genre.search(params[:search])
      @keywords = Keyword.search(params[:search])
    end

    if @authors.blank? && @books.blank? && @genres.blank?
      flash[:notice] = "Your search yielded no results."
    end

  end

end
