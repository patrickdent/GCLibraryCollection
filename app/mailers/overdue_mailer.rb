class OverdueMailer < ActionMailer::Base
  default from: "from@example.com"

  @last_sent = Date.new(2000,1,1)

  def overdue_reminder(user)
    @user = user
    mail(to: @user.email, subject: 'Overdue Reminder')
  end

  def self.last_sent=(date)
    @last_sent = date
  end

  def self.last_sent
    @last_sent
  end
end
