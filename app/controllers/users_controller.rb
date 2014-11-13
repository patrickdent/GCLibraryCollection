class UsersController < ApplicationController
  include ApplicationHelper
  include UsersHelper

  before_filter :authenticate_user!
  before_filter :is_librarian?, only: [:new, :create, :edit, :update, :index]
  before_filter :is_admin?, only: :destroy
  before_filter :find_user, only: [:show, :edit, :destroy, :update, :promote]


  def promote
    @user.add_role :admin
    redirect_to users_path
  end

  def edit
  end

  def index
    @users = User.all.order('sort_by ASC')
  end

  def update

    case params[:user][:role]
      when "admin"
        @user.roles = []
        @user.add_role(:admin)
      when "librarian"
        @user.roles = []
        @user.add_role(:librarian)
      else
    end

    if @user.update(user_params)
      flash[:notice] = "Update Successful!"
      redirect_to users_path
    else 
      flash[:error] = "Update Failed"
      redirect_to :back
    end 
  end

  def show
  end

  private 
  def find_user 
    @user = User.find(params[:id])
  end 
end
