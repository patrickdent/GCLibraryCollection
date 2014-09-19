class BooksController < ApplicationController
  include BooksHelper
  include ApplicationHelper

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_book, only: [:show, :edit, :destroy, :update]
  
  def index
    @books = Book.all
  end

  def new 
    is_admin?
    @book = Book.new 
  end 

  def create 
    is_admin?
    @book = Book.new(book_params)
    if @book.save 
      flash[:notice] = "Book Created"
      redirect_to books_path
    else 
      flash[:alert] = "Book Creation Failed"
      redirect_to new_book_path
    end 
  end 

  def show
  end

  def edit 
    is_admin? 
  end 

  def destroy 
    is_admin? 
    @book.destroy 
    flash[:notice] = "Delete Successful!"
    redirect_to books_path 
  end 

  def update 
    is_admin?
    if @book.update(book_params)
      flash[:notice] = "Update Successful!"
      redirect_to book_path(@book)
    else 
      flash[:error] = "Update Failed"
      redirect_to edit_book_path
    end 
  end 

  private 
  def find_book 
    @book = Book.find(params[:id])
  end 
end
