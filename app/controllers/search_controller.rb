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
      @authors = Author.search(params[:search]).uniq
      @books = Book.search(params[:search]).uniq
      @genres = Genre.search(params[:search]).uniq
      @keywords = Keyword.search(params[:search]).uniq
      @users = User.search(params[:search]).uniq if is_librarian?
    end

    if @authors.blank? && @books.blank? && @genres.blank? && @keywords.blank? && @users.blank?
      flash[:alert] = "Your search yielded no results."
      redirect_to :back
    end
  end

  def import
  end

  def scrape
    @books = []
    params[:isbn].each do |isbn|
      unless isbn.empty?
        new_book = Search.scrape(isbn.strip.gsub("-", ""))
        @books.push(new_book) if new_book
      end
    end

    if @books.empty?
      flash[:error] = "Book Upload Failed"
      return redirect_to import_path
    end

    flash[:notice] = "Books Added"
    redirect_to import_results_path(books: @books)
  end

  def import_results
    ids = params[:books] || []
    @books = ids.map{|id| Book.find_by(id: id.to_i)}
  end

end
