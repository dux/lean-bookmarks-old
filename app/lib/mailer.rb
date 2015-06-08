class Mailer < LuxMailer

  before do
    @from = 'rejotl@gmail.com'
  end

  def confirm_email(email)
    @to = email
    @link = "#{Lux.host}/action/confirm_email?data=#{Crypt.encrypt(@to)}"
  end

  def self.confirm_email_preview
    render(:confirm_email, 'rejotl@gmailcom')
  end

end