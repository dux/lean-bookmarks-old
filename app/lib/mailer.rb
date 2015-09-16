class Mailer < LuxMailer

  before do
    @from = 'StashBuckets <no-reply@stashbuckets.com>'
  end

  after do
    if Page.dev? && @to != 'rejotl@gmail.com'
      @subject = "[For: #{@to}] #{@subject}"
      @to = 'rejotl@gmail.com'
    end
  end

  def confirm_email(email)
    @subject = 'Wellcom to Lux!'
    @to = email
    @link = "#{Page.host}/users/profile?user_hash=#{Crypt.encrypt(@to)}"
  end

  def self.confirm_email_preview
    confirm_email('rejotl@gmailcom')
  end

end