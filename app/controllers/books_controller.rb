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
    @book.authors << @author
 end

  def create
    @book = Book.new(book_params)
    if @book.save
      if params[:book][:keyword_ids]
        params[:book][:keyword_ids].each do |id|
          BookKeyword.create(keyword_id: id, book_id: @book.id) unless id.empty?
        end
      end
      BookAuthor::create_multi(@book, params[:book_author]) if params[:book_author]
      flash[:notice] = "Book Created"
      redirect_to book_path(@book)
    else
      flash[:error] = "Book Creation Failed"
      redirect_to new_book_path
    end
  end

  def show
    @primary = @book.primary_author
    @other_contributors = @book.other_contributors(@primary)

    if current_user && is_given_user_or_librarian?(current_user)
      @loans = Loan.where(book_id: @book.id).joins(:user)
      .order("returned_date ASC", sort_column("start_date") + " " + sort_direction("desc")).paginate(:page => params[:page], :per_page => 50)
    end
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
    @book.attributes = book_params

    if params[:book_author]
      to_create = extract_new_book_authors

      BookAuthor::update_or_delete_from_book(@book, params[:book_author])
      BookAuthor::create_multi(@book, to_create)
    end

    if @book.save
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
    @multi_loan_available = is_given_user_or_librarian?(current_user) && (@books - Book.available_to_loan).empty? && (@books.length < 6)
  end

  def remove_copy
    if @book.count > 1 && @book.update_attributes(count: @book.count - 1) then
      @book.update_availability
      flash[:notice] = "Copy Removed"
    else
      flash[:error] = "Unable To Remove Copy"
    end
    redirect_to :back
  end

  private
  def find_book
    @book = Book.find_by(id: params[:id])
    redirect_to root_path and return unless @book
  end

  def sort_column(default = "title")
    params[:sort] ? params[:sort] : default
  end

  def sort_direction(default = "asc")
    %w[asc desc].include?(params[:direction]) ? params[:direction] : default
  end

  def book_params
    params.require(:book).permit(:title, :isbn, :genre_id, :created_at, :updated_at,
                                 :publisher, :publish_date, :publication_place,
                                 :language, :pages, :location, :available, :count,
                                 :in_storage, :missing, :notable, :keep_multiple)
  end

  def extract_new_book_authors
    to_create = Hash.new

    params[:book_author].keys.each do |id_or_string|
      unless id_or_string.to_i > 0
        to_create[id_or_string] = params[:book_author].delete(id_or_string)
      end
    end
    return to_create
  end
end
