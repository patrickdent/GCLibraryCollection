class RegistrationsController < Devise::RegistrationsController

def create 
  if params[:user][:email].empty? && params[:user][:username].empty?
    flash[:error] = "Error: You must have either an email or username"
    redirect_to :back and return 
  end 
  super
end 

end