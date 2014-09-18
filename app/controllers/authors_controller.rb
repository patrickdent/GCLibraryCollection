class AuthorsController < ApplicationController
  include ApplicationHelper
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_author, only: [:show, :edit, :destroy, :update]

  def index
    @authors = Author.all
  end 

  def new 
    is_admin?
    @author = Author.new 
  end 

  def create 
    is_admin?
    @author = Author.new(author_params)
    if @author.save 
      flash[:notice] = "Author Created"
      redirect_to authors_path
    else 
      flash[:alert] = "Author Creation Failed"
      redirect_to new_author_path
    end 
  end 

  def edit 
    is_admin?
  end 

  def update 
    is_admin?
    if @author.update(author_params)
      flash[:notice] = "Update Successful!"
      redirect_to author_path(@author)
    else 
      flash[:error] = "Update Failed"
      redirect_to edit_author_path
    end 
  end 

  def show
  end 

  def destroy 
    is_admin?
    @author.destroy 
    flash[:notice] = "Delete Successful!"
    redirect_to authors_path
  end 

  private 
  def find_author
    @author = Author.find(params[:id])
  end 

  def author_params
    params.require(:author).permit(:name, :id)
  end 
end
