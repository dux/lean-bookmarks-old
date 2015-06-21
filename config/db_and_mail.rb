# database
db_config = YAML.load_file('./auto_migrate/config/database.yml')[Lux.dev? ? 'development' : 'production']
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
