class UsersController < ApplicationController

  before_filter :is_librarian?, only: [:new, :create, :edit, :update]
  before_filter :is_admin?, only: :destroy

  def edit
  end

  def index
  end

  def update
  end

  def show
  end

end
