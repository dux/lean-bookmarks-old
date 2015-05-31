require './lux/init'

get '*' do
  return Template.render('main/index') unless @root_part

  case @root_part
    when :api;   return Template.part('api')
    when :user;  return Main::UserCell.resolve(*@path)
    else
      Lux.status :not_found, "Unknown route for path /#{@root_part}"
  end
end

post '/api/*' do
  return Lux::ApiCell.resolve(*@path)
end

post '*' do
  Lux.status :forbiden, 'Request not allowed'
end
