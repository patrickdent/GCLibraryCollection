require "spec_helper"

describe OverdueMailer, type: :mailer do
  before :all do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  after :all do
    DatabaseCleaner.clean
  end

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    OverdueMailer.overdue_reminder(user).deliver
    @mail = ActionMailer::Base.deliveries.first
  end

  after(:each) do
    ActionMailer::Base.deliveries.clear
  end

  let(:user) { create :user }
  let(:loan) { create :loan, user: user, due_date: (Date.today - 1.week) }

  it 'should send an email' do
    ActionMailer::Base.deliveries.count.should == 1
  end

  it "has the correct from" do
    expect(@mail.from).to include("from@example.com")
  end

  it "renders the subject" do
    subject = "Overdue Reminder"
    expect(@mail.subject).to eq(subject)
  end

  it "has the correct to" do
    expect(@mail.to).to include(user.email)
  end

  it "has the correct body text" do
    expect(@mail.body).to include("This is a friendly reminder ")
  end

  it "has a last_sent class instance variable that is accessible" do
    expect(OverdueMailer.last_sent).to_not be nil

    expect(OverdueMailer.last_sent).to_not eq(Date.parse("2000-1-2"))
    OverdueMailer.last_sent = Date.new(2000, 1, 2)
    expect(OverdueMailer.last_sent).to eq(Date.parse("2000-1-2"))
  end

end
