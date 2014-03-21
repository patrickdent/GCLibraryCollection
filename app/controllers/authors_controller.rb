class AuthorsController < ApplicationController

  def index
    @authors = Author.all
  end 

  def search
    @authors = Author.search(params[:search])
  end

  def show
    @author = Author.find(params[:id])
  end 
end
