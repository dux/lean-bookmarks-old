class Mailer < LuxMailer

  before do
    @from = 'rejotl@gmail.com'
  end

  after do
    @subject = "[For: #{@to}] #{@subject}"
    @to = 'reic.dino@gmail.com'
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