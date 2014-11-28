class BooksController < ApplicationController
  include BooksHelper
  include UserRoleHelper

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_book, only: [:show, :edit, :destroy, :update]
  before_filter :is_admin?, only: [:new, :create, :destroy]
  before_filter :is_librarian?, only: [:edit, :update] 

  
  def index
    @books = Book.all.order('title ASC')
  end

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
    if @book.destroy 
      flash[:notice] = "Delete Successful!"
      redirect_to books_path 
    else 
      flash[:error] = "Delete Failed"
      redirect_to books_path 
    end 
  end 

  def update
    respond_to do |format|
      format.html do
        if @book.update(book_params)
          flash[:notice] = "Update Successful!"
          redirect_to book_path(@book)
        else 
          flash[:error] = "Update Failed"
          redirect_to edit_book_path
        end
      end
      format.js do
        if @book.update(book_params)
          flash[:notice] = "Update Successful!"
        else 
          flash[:error] = "Update Failed"
        end
      end
    end 
  end 

  def list 
    @book = Book.find_by(id: params[:book][:id])
    @book.selected = params[:book][:selected]
    if @book.save!
      render json: {status: :success }
    else 
      render json: {status: :failure }
    end    
  end 

  def clear_list 
    
  end 

  def show_list 
    @books = Book.where(selected: true)
  end 

  private 
  def find_book 
    @book = Book.find_by(id: params[:id])
  end 
end
