class LoansController < ApplicationController

  include UserRoleHelper
  include LoanHelper

  before_filter :is_librarian?, only: [:new, :create, :renew, :return]
  before_filter :authenticate_user!, only: [:new, :create, :renew]
  before_filter :find_loan, only: [:renew, :return]

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

  def renew
    if @loan.renew_loan
      flash[:notice] = "Loan Renewed"
    else
      flash[:alert] = "Loan Limit Reached"
    end
    redirect_to user_path(@loan.user_id)
  end

  def return
    if @loan.return_loan
      flash[:notice] = "Loan Returned"
    else
      flash[:alert] = "Loan Return Faild"
    end
    redirect_to user_path(@loan.user_id)
  end
end