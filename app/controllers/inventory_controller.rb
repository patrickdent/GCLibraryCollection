class InventoryController < ApplicationController
  include UserRoleHelper

  before_filter :is_admin?

  def genre_select
    @genres = Genre.all
  end

  def checklist
    @genre = Genre.find_by(params[:genre_id]) if params[:genre_id]
    @last_inventoried = (@genre.last_inventoried ? @genre.last_inventoried.strftime("%m/%d/%Y at %I:%M%p") : "never")
    render layout: "minimal"
  end

  def update_checklist_item
    @book = Book.find_by(id: params[:id])
    params[:book].delete_if { |key, value| value == '' }
    if @book.update_attributes!(book_params)
      render json: {status: "ok", book: @book.reload.as_json}
    else
      render json: {status: "unprocessable entity"}
    end
  end

  def complete_inventory
    @genre = Genre.find_by(params[:genre_id])
    @genre.update_attributes(last_inventoried: DateTime.now)
    redirect_to genre_path(@genre)
  end

  private
  def book_params
    params.require(:book).permit(:title, :isbn, :language, :pages, :location, :count,
                                 :publisher, :publish_date, :publication_place,
                                 :in_storage, :missing, :notable, :keep_multiple, :inventoried)
  end
end