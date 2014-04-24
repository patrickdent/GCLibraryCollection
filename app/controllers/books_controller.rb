class BooksController < ApplicationController
  #to restrict methods, use this before filter: 
  before_filter :authenticate_user!, except: [:index, :show]
  
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end
end
