# LuxMailer.render(:method_name, *args)

class LuxMailer
  @@ivh = {}


  def self.ivh
    @@ivh
  end

  def self.before(&block)
    
  end

  # Mailer.render(:confirm_email, 'rejotl@gmailcom')
  def self.render(template, *args)
    obj = new
    obj.send(template, *args)
    @@ivh = obj.instance_variables_hash
    Template.render("mailer/#{template}", @@ivh);
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

end