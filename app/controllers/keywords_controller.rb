class KeywordsController < ApplicationController

  include UserRoleHelper

  before_filter :authenticate_user!, only: [:new, :create, :edit, :destroy, :update]
  before_filter :find_keyword, only: [:show, :edit, :destroy, :update]
  before_filter :is_librarian?, only: [:new, :create, :edit, :destroy, :update]

  def index
    @keywords = Keyword.all.order('name ASC')
  end

  def new 
    @keyword = Keyword.new 
  end 

  def create 
    @keyword = Keyword.new(keyword_params)
    if @keyword.save 
      flash[:notice] = "Keyword Created"
      redirect_to keywords_path
    else 
      flash[:alert] = "Keyword Creation Failed"
      redirect_to new_keyword_path
    end 
  end 

  def show
  end

  def edit 
  end 

  def destroy 
    @keyword.destroy 
    flash[:notice] = "Delete Successful!"
    redirect_to keywords_path 
  end 

  def update 
    if @keyword.update(keyword_params)
      flash[:notice] = "Update Successful!"
      redirect_to keyword_path(@keyword)
    else 
      flash[:error] = "Update Failed"
      redirect_to edit_keyword_path
    end 
  end 

  private 
  def find_keyword
    @keyword = Keyword.find(params[:id])
  end 

  def keyword_params
    params.require(:keyword).permit(:name, :id)
  end 
end