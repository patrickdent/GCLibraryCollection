class InventoryController < ApplicationController
  include UserRoleHelper

  before_filter :is_admin?

  def genre_select
    @genres = Genre.all
  end

  def checklist
    @genre = Genre.find_by(params[:genre_id]) if params[:genre_id]
    render layout: "minimal"
  end

  def update_checklist_item
    @book = Book.find_by(id: params[:id])
    params[:book].delete_if { |key, value| value == '' }
    @book.update_attributes(params[:book])
    redirect_to :back
  end
end