class LoansController < ApplicationController

  include UserRoleHelper
  include LoanHelper

  before_filter :is_librarian?, only: [:new, :create]

  def update
  end

  def new
  end

  def create
    @loan = Loan.new(loan_params)
    if @loan.save 
      flash[:notice] = "Loan Created"
    else 
      flash[:alert] = "Loan Creation Failed"
    end 
    redirect_to user_path(@loan.user_id)
  end
end