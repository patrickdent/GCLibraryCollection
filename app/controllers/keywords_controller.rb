class KeywordsController < ApplicationController

  include ApplicationHelper
  before_filter :find_keyword, only: [:show, :edit, :destroy, :update]

  def index
    @keywords = Keyword.all
  end

  def new 
    is_admin?
    @keyword = Keyword.new 
  end 

  def create 
    is_admin?
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
    is_admin? 
  end 

  def destroy 
    is_admin? 
    @keyword.destroy 
    flash[:notice] = "Delete Successful!"
    redirect_to keywords_path 
  end 

  def update 
    is_admin?
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