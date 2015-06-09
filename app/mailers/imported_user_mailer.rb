class ImportedUserMailer < ActionMailer::Base
  default from: "resources@gaycity.org"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Important Information Regarding your Library Account')
  end
end
