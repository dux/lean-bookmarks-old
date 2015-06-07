class Mailer

  def default_from
    'rejotl@gmail.com'  
  end

  def render
    # renda iz ./app/views/mailer foldera
  end

  def mail(opts)
    Mail.new do
      from    opts[:from] || default_from
      to      opts[:to]
      subject opts[:subject]
      body    opts[:body]
    end
  end

  def deliver(opts)
    mail(opts).deliver!
  end

  def confirm_email_preview
    @link = 'some link'
  end



end