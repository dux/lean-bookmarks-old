class Mailer < LuxMailer

  before do
    @from = 'no-reply@stashbuckets.com'
  end

  after do
    if Lux.dev? && @to != 'rejotl@gmail.com'
      @subject = "[For: #{@to}] #{@subject}"
      @to = 'rejotl@gmail.com'
    end
  end

  def confirm_email(email)
    @subject = 'Wellcom to Lux!'
    @to = email
    @link = "#{Lux.host}/users/profile?user_hash=#{Crypt.encrypt(@to)}"
  end

  def self.confirm_email_preview
    confirm_email('rejotl@gmailcom')
  end

end