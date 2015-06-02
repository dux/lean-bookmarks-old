require './lux/init'

get '*' do
  return @body if @body
  return Template.render('main/index') unless @root_part

  case @root_part.singularize.to_sym
    when :api;   return Template.part('api')
    when :user;  return Main::UserCell.get(@path)
    else
      Lux.status :not_found, "Unknown route for path /#{@root_part}"
  end
end

post '/api/*' do
  return Lux::ApiCell.get(@path)
end

post '*' do
  Lux.status :forbiden, 'Request not allowed'
end
