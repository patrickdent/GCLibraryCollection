class InventoryController < ApplicationController
  include UserRoleHelper

  before_filter :is_admin?

  def genre_select
    @locations = Book.all.collect(&:location).uniq.compact.reject(&:empty?)
    @genres = Genre.all
  end

  def checklist
    if params[:genre_id]
      @genre = Genre.find_by(id: params[:genre_id])
      if @genre
        @books = @genre.books
        @last_inventoried = (@genre.last_inventoried ? @genre.last_inventoried.localtime.strftime("%m/%d/%Y at %I:%M%p") : "never")
      end
    elsif params[:location]
      @location = params[:location]
      @books = Book.where(location: params[:location])
    end
    render layout: "minimal"
  end

  def update_checklist_item
    @book = Book.find_by(id: params[:id])
    params[:book].delete_if { |key, value| value == '' }
    if @book.update_attributes!(book_params)
      @book.update_availability
      render json: {status: "ok", book: @book.reload.as_json}
    else
      render json: {status: "unprocessable entity"}
    end
  end

  def complete_inventory
    if params[:genre_id]
      @genre = Genre.find_by(id: params[:genre_id])
      @genre.update_attributes(last_inventoried: DateTime.now)
      @genre.books.each do |b|
        b.update_attributes(inventoried: false)
      end
      return redirect_to genre_path(@genre)
    elsif params[:location]
      @books = Book.where(location: params[:location])
      @books.each do |b|
        b.update_attributes(inventoried: false)
      end
      return redirect_to admin_dashboard_path
    end
  end

  private
  def book_params
    params.require(:book).permit(:title, :isbn, :language, :pages, :location, :count,
                                 :publisher, :publish_date, :publication_place,
                                 :in_storage, :missing, :notable, :keep_multiple, :inventoried)
  end
end
