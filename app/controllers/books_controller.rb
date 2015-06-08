class BooksController < ApplicationController
  include UserRoleHelper

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_book, only: [:show, :edit, :destroy, :update, :remove_copy]
  before_filter :is_admin?, only: [:new, :create, :destroy, :remove_copy]
  before_filter :is_librarian?, only: [:edit, :update, :list, :clear_list, :show_list]
  helper_method :sort_column, :sort_direction

  def index
    case params["sort"]
    when "name"
      @books = Book.joins(:genre).includes(:authors).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 50)
    else
      @books = Book.includes(:authors, :genre).order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 50)
    end
  end

  def new
    @book = Book.new
    @author = Author.new
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
    if is_librarian?
      @loans = Loan.where(book_id: @book.id).joins(:user)
      .order("returned_date ASC", sort_column("start_date") + " " + sort_direction("desc")).paginate(:page => params[:page], :per_page => 50)
    end
  end

  def edit
    @author = Author.new
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
      @book.update_availability
      flash[:notice] = "Update Successful!"
      redirect_to book_path(@book)
    else
      flash[:error] = "Update Failed"
      redirect_to edit_book_path
    end
  end

  def list
    @book = Book.find_by(id: params[:book][:id])
    session[:selected_books] = [] if session[:selected_books].nil?

    if @book &&  params[:book][:selected] == "true"
      session[:selected_books] << @book.id
      render json: {status: :success } and return
    end

    if @book && params[:book][:selected] == "false"
      session[:selected_books].delete(@book.id)
      render json: {status: :success } and return
    end

    render json: {status: :failure } and return
  end

  def clear_list
    session[:selected_books] = nil
    render inline: "location.reload();"
  end

  def show_list
    case params["sort"]
    when "name"
      @books = Book.joins(:genre).includes(:authors).where(id: session[:selected_books])
      .order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 50)
    else
      @books = Book.includes(:authors, :genre).where(id: session[:selected_books])
      .order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 50)
    end
    @multi_loan_available = is_librarian? && (@books - Book.available_to_loan).empty? && (@books.length < 6)
  end

  def remove_copy
    if @book.count > 1 && @book.update_attributes(count: @book.count - 1) then
      flash[:notice] = "Copy Removed"
    else
      flash[:error] = "Unable To Remove Copy"
    end
    redirect_to :back
  end

  private
  def find_book
    @book = Book.find_by(id: params[:id])
    unless @book redirect_to root_path and return
  end

  def sort_column(default = "title")
    params[:sort] ? params[:sort] : default
  end

  def sort_direction(default = "asc")
    %w[asc desc].include?(params[:direction]) ? params[:direction] : default
  end

  def book_params
    params.require(:book).permit!
  end
end
