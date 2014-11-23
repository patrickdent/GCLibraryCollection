class BooksController < ApplicationController
  include BooksHelper
  include ApplicationHelper

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_book, only: [:show, :edit, :destroy, :update]
  before_filter :is_admin?, only: [:new, :create, :destroy]
  before_filter :is_librarian?, only: [:edit, :update] 

  
  def index
    @books = Book.all.order('title ASC')
  end

  # def index(new_book_array)
  #   @books = Book.find(new_book_array)
  # end

  def new
    @book = Book.new 
  end 

  def create
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
  end 

  def destroy 
    @book.destroy 
    flash[:notice] = "Delete Successful!"
    redirect_to books_path 
  end 

  def update
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
