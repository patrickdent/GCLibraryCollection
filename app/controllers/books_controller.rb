class BooksController < ApplicationController
  include BooksHelper
  include UserRoleHelper

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_book, only: [:show, :edit, :destroy, :update]
  before_filter :is_admin?, only: [:new, :create, :destroy]
  before_filter :is_librarian?, only: [:edit, :update, :list, :clear_list, :show_list]


  def index
    @books = Book.includes(:authors, :genre).order('title ASC')
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      flash[:notice] = "Book Created"
      redirect_to root_path
    else
      flash[:error] = "Book Creation Failed"
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
    else
      flash[:error] = "Delete Failed"
    end
      redirect_to root_path
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
    Book.where(selected: true).update_all(selected: false)
    render inline: "location.reload();"
  end

  def show_list
    @books = Book.includes(:authors, :genre).where(selected: true)
    @multi_loan_available = is_librarian? && (@books - Book.available_to_loan).empty? && (@books.length < 6)
  end

  private
  def find_book
    @book = Book.find_by(id: params[:id])
  end
end
