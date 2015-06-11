# LuxMailer.render(:method_name, *args)

class LuxMailer
  @@ivh = {}
  @@before_and_after = {}

  def self.ivh
    @@ivh
  end

  def self.before(&block)
    n = self.name.underscore
    @@before_and_after[n] ||= { b:[], a:[] }
    @@before_and_after[n][:b].push(block)
  end

  def self.after(&block)
    n = self.name.underscore
    @@before_and_after[n] ||= { b:[], a:[] }
    @@before_and_after[n][:a].push(block)
  end

  # Mailer.render(:confirm_email, 'rejotl@gmailcom')
  def self.render(template, *args)
    obj = new

    n = self.name.underscore
    @@before_and_after[n] ||= { b:[], a:[] }

    for m in @@before_and_after[n][:b]
      obj.instance_exec(&m)
    end

    obj.send(template, *args)

    for m in @@before_and_after[n][:a]
      obj.instance_exec(&m)
    end

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