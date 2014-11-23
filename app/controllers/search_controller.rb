class SearchController < ApplicationController
  include UserRoleHelper

  before_filter :authenticate_user!, except: [:search]
  before_filter :is_admin?, only: [:import, :scrape]

  
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

  def import 
  end 

  def scrape
    isbn = params[:isbn]
    isbn = isbn.delete(" ")

    @book = Search.scrape(isbn)
    redirect_to edit_book_path(@book) and return if @book

    flash[:error] = "Book Upload Failed"
    redirect_to import_path
  end

end
