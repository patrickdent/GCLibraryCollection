module LoanHelper
  def loan_params
    params.require(:loan).permit(:book_id, :user_id, :id)
  end 

  def find_loan
    @loan = Loan.find(params[:id])
  end
end
