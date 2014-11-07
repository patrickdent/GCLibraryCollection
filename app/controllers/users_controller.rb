class UsersController < ApplicationController
  include ApplicationHelper

  before_filter :authenticate_user!
  before_filter :is_librarian?, only: [:new, :create, :edit, :update, :index]
  before_filter :is_admin?, only: :destroy

  def edit
  end

  def index
    @users = User.all
  end

  def update
  end

  def show
  end

end
