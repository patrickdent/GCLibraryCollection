class KeywordsController < ApplicationController
  # include BooksHelper
  include ApplicationHelper
  #to restrict methods, use this before filter: 
  # before_filter :authenticate_user!, except: [:index, :show]
  
  def index
    @keyword = Keyword.all
  end

  def show
    @keyword = Keyword.find(params[:id])
  end
end