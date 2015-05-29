class UsersController < ApplicationController
  include UserRoleHelper
  include UsersHelper

  before_filter :authenticate_user!
  before_filter :is_librarian?, only: [:edit, :update, :index, :send_reminders]
  before_filter :is_admin?, only: :destroy
  before_filter :find_user, only: [:show, :edit, :destroy, :update]
  helper_method :sort_column, :sort_direction

  def edit
  end

  def index
    @users = User.active.order(sort_column + " " + sort_direction)
    .paginate(:page => params[:page], :per_page => 50)
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
      redirect_to user_path(@user)
    else
      flash[:error] = "Update Failed"
      redirect_to :back
    end
  end

  def show
    if !is_given_user_or_librarian?(@user) then
      flash[:error] = "You are not authorized"
      redirect_to root_path
    end

    @loans = Loan.where(user_id: @user.id).joins(:book)
    .order("returned_date ASC", sort_column("start_date") + " " + sort_direction("desc"))
    .paginate(:page => params[:page], :per_page => 50)  
  end

  def destroy
    if current_user == @user then
      flash[:error] = "You cannot delete yourself"
      redirect_to :back
    elsif @user.deactivate then
      flash[:notice] = "Delete Successful!"
      redirect_to users_path
    else
      flash[:error] = "Delete Failed"
      redirect_to users_path
    end
  end

  def send_reminders
    User.all.each do |u|
      if !u.loans.overdue.empty?
        if !u.email.blank?
          OverdueMailer.overdue_reminder(u).deliver
        else
          # add user to a list, return that list with the success view/popup
        end
      end
    end
    OverdueMailer.last_sent = Date.today
    flash[:notice] = "Mail successfully sent"
    redirect_to :back
  end

  private
  def find_user
    @user = User.find_by(id: params[:id])
  end

  def sort_column(default = "preferred_first_name")
    params[:sort] ? params[:sort] : default
  end
  
  def sort_direction(default = "asc")
    %w[asc desc].include?(params[:direction]) ? params[:direction] : default
  end
end
