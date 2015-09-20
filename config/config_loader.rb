db_config = YAML.load_file('./config/database.yml')

if Page.dev?
  # ENV['COFFEE_PATH'] = '/usr/local/bin/coffee'
  db_config = db_config['development']
else
  db_config = db_config['production']
end

# set up database connection
ActiveRecord::Base.establish_connection(db_config)

# mail
Mail.defaults do
  delivery_method :smtp, {
    :address        => 'smtp.mandrillapp.com',
    :port           => 587,
    :domain         => 'sessionrobotics.com',
    :enable_starttls_auto => true,
    :authentication => :plain,
    :user_name      => 'rejotl@gmail.com',
    :password       => '8f5-59-ltEqpNPDLUp2eCA'
  }
end

# mailgun
# config.action_mailer.smtp_settings = {
#   :authentication => :plain,
#   :address => "smtp.mailgun.org",
#   :port => 587,
#   :domain => "MYDOMAIN.mailgun.org",
#   :user_name => "postmaster@MYDOMAIN.mailgun.org",
#   :password => "MYPASSWORD"
# }