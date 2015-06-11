class BeforeAndAfter

  def initialzie
    @bef_and_aft = { }
  end

  def add(what, &block)
    @bef_and_aft[what] ||= []
    @bef_and_aft[what].push(block)
  end

  def exec(what, obj)
    for m in @bef_and_aft[what]
      obj.instance_exec(&m)
    end
  end

end

# LuxMailer.render(:method_name, *args)

class LuxMailer
  @@ivh = {}
  @@before_and_after = BeforeAndAfter.new

  def self.ivh
    @@ivh
  end

  def self.before(&block)
    @@before_and_after.add :before, block
  end

  def self.after(&block)
    @@before_and_after.add :after, block
  end

  # Mailer.render(:confirm_email, 'rejotl@gmailcom')
  def self.render(template, *args)
    obj = new
    
    @@before_and_after.exec :before, obj

    obj.send(template, *args)
    
    @@before_and_after.exec :after, obj

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