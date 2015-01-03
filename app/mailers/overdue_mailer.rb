class OverdueMailer < ActionMailer::Base
  default from: "from@example.com"

  def overdue_reminder(user)
    @user = user
    mail(to: @user.email, subject: 'Overdue Reminder')
  end 
end
