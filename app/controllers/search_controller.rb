class SearchController < ApplicationController
  include UserRoleHelper

  before_filter :authenticate_user!, except: [:search]
  before_filter :is_admin?, only: [:import, :scrape]


  def search
    if params[:search] == ""
      flash[:alert] = "Please enter a search term."
      redirect_to :back
      return
    else
      @authors = Author.search(params[:search])
      @books = Book.search(params[:search])
      @genres = Genre.search(params[:search])
      @keywords = Keyword.search(params[:search])
      @users = User.search(params[:search]) if is_librarian?
    end

    if @authors.blank? && @books.blank? && @genres.blank? && @keywords.blank? && @users.blank?
      flash[:alert] = "Your search yielded no results."
      redirect_to :back
    end

  end

  def import
  end

  def scrape
    isbn = params[:isbn].strip.gsub("-", "")

    if (@book = Search.scrape(isbn))
      flash[:notice] = "Book Added: Please complete additional fields"
      redirect_to edit_book_path(@book) and return
    end

    flash[:error] = "Book Upload Failed"
    redirect_to import_path
  end

end
