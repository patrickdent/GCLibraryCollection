class AuthorsController < ApplicationController
  include UserRoleHelper
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_author, only: [:show, :edit, :destroy, :update]
  before_filter :is_admin?, only: [:new, :create, :edit, :destroy, :update]


  def index
    @authors = Author.all.order('sort_by ASC')
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      flash[:notice] = "Author Created"
      redirect_to authors_path
    else
      flash[:error] = "Author Creation Failed"
      redirect_to new_author_path
    end
  end

  def edit
  end

  def update
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
    if @author.destroy
      flash[:notice] = "Delete Successful!"
    else
      flash[:error] = "Delete Failed"
    end
    redirect_to authors_path
  end

  private
  def find_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :id, :sort_by)
  end
end
