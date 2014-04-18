class AuthorsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  def index
    @authors = Author.all
  end 

  def show
    @author = Author.find(params[:id])
  end 
end
