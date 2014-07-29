class BooksController < ApplicationController
  include BooksHelper
  include ApplicationHelper
  #to restrict methods, use this before filter: 
  before_filter :authenticate_user!, except: [:index, :show]
  
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def edit 
    is_admin? 
    @book = Book.find(params[:id])

  end 

  def update 
    is_admin?
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book)
      flash[:notice] = "Update Successful!"
    else 
      redirect_to edit_book_path
      flash[:error] = "Update Failed"
    end 
  end 
end
