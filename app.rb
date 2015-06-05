require './lux/init'

get '*' do
  return @body if @body
  return Template.render('main/index') unless @root_part

  case @root_part.singularize.to_sym
    when :api
      return LuxApiRender.render_root unless @path[0]
      return LuxApiRender.get(*@path) if Lux.dev?
      return Lux.error 'You can only POST to API in production'
    when :user
      return Main::UserCell.get(@path)
    else
      Lux.status :not_found, "Unknown route for path /#{@root_part}"
  end
end

post '/api/*' do
  return LuxApiRender.get *@path
end

post '*' do
  Lux.status :forbiden, 'Request not allowed'
end
