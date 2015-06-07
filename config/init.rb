# database
ActiveRecord::Base.establish_connection(
  adapter:    'postgresql',
  host:       'localhost',
  database:   'cleanpay',
  username:   'dux',
  password:   "!Netlife",
  port:       5432
)

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
