require './lux/init'

get '*' do
  # @body can be defined in before filter
  return @body if @body

  # /
  return Template.render('main/index') unless @root_part

  # application routes
  case @root_part.singularize.to_sym
    when :link
      return Main::LinkCell.raw(@path)
    when :bucket
      return Main::BucketCell.raw(@path)
    when :user
      return Main::UserCell.raw(@path)
    when :action
      return Main::ActionCell.raw(@first_part)
    when :css
      return Template.render('main/css')
    else
      Lux.status :not_found, "Unknown route for path /#{@root_part}"
  end

  # debug routes
  if Lux.dev?
    case @root_part.singularize.to_sym
      when :lux
        return LuxRenderCell.dev_row(*@path)
      when :api
        return LuxApi.raw(*@path)
    end
  end

  Lux.status :not_found, "Page not found not route /#{@root_part}"
end

post '/api/*' do
  return LuxApi.raw(*@path)
end

post '*' do
  Lux.status :forbiden, 'Request not allowed'
end
