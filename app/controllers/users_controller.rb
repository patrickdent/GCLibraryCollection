class UsersController < ApplicationController
  include ApplicationHelper
  include UsersHelper

  before_filter :authenticate_user!
  before_filter :is_librarian?, only: [:edit, :update, :index]
  before_filter :is_admin?, only: :destroy
  before_filter :find_user, only: [:show, :edit, :destroy, :update]

  def edit
  end

  def index
    @users = User.all.order('sort_by ASC')
  end

  def update

    if current_user.has_role? :admin then
      @user.roles = []
      case params[:user][:role]
        when "admin"
          @user.add_role(:admin)
        when "librarian"
          @user.add_role(:librarian)
        else
          @user.roles = []
      end
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

  def destroy
    @user.destroy 
    flash[:notice] = "Delete Successful!"
    redirect_to users_path 
  end

  private 
  def find_user 
    @user = User.find(params[:id])
  end 
end
