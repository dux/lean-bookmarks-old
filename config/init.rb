ActiveRecord::Base.establish_connection(
  adapter:    'postgresql',
  host:       'localhost',
  database:   'cleanpay',
  username:   'dux',
  password:   "!Netlife",
  port:       5432
  # schema_search_path: 'cleanpay'
)

