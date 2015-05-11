class KeywordsController < ApplicationController

  include UserRoleHelper
  include KeywordHelper

  before_filter :authenticate_user!, only: [:new, :create, :edit, :destroy, :update]
  before_filter :find_keyword, only: [:show, :edit, :destroy, :update]
  before_filter :is_librarian?, only: [:new, :create, :edit, :destroy, :update]
  helper_method :sort_column, :sort_direction

  def index
    @keywords = Keyword.all.order(sort_column + " " + sort_direction).paginate(:page => params[:page], :per_page => 50)
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
    @books = @keyword.books.includes(:authors, :genre).order(sort_column("title") + " " + sort_direction).paginate(:page => params[:page], :per_page => 50)
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

  def sort_column(default = "name")
    params[:sort] ? params[:sort] : default
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end