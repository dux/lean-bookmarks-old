# sugessted usage
# Mailer.deliver(:confirm_email, 'rejotl@gmailcom')
# Mailer.render(:confirm_email, 'rejotl@gmailcom')

# natively works like
# Mailer.prepare(:confirm_email, 'rejotl@gmailcom').deliver
# Mailer.prepare(:confirm_email, 'rejotl@gmailcom').body

# Rails mode via method missing is suported
# Mailer.confirm_email('rejotl@gmailcom').deliver
# Mailer.confirm_email('rejotl@gmailcom').body

class LuxMailer
  @@ivh = {}
  @@before_and_after = BeforeAndAfter.new

  def self.ivh
    @@ivh
  end

  def self.before(&block)
    @@before_and_after.add :before, &block
  end

  def self.after(&block)
    @@before_and_after.add :after, &block
  end

  # Mailer.prepare(:confirm_email, 'rejotl@gmailcom')
  def self.prepare(template, *args)
    obj = new
    obj.instance_variable_set :@_template, template

    @@before_and_after.exec :before, obj
    obj.send(template, *args)
    @@before_and_after.exec :after, obj

    @@ivh = obj.instance_variables_hash
    obj
  end

  def self.render(method_name, *args)
    send(method_name, *args).body
  end

  def deliver
    raise "From in mailer not defined" unless @from
    raise "To in mailer not defined" unless @to
    raise "Subject in mailer not defined" unless @subject

    m = Mail.new
    m[:from]         = @from
    m[:to]           = @to
    m[:subject]      = @subject
    m[:body]         = body
    m[:content_type] = 'text/html; charset=UTF-8'
    m.deliver!
  end

  def self.deliver
    send(method_name, *args).deliver
  end

  def body
    Template.render("mailer/#{@_template}", @@ivh);
  end

  def self.method_missing(method_sym, *args)
    prepare(method_sym, *args)
  end

end