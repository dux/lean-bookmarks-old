require './lux/init'

get '*' do
  # @body can be defined in before filter
  return @body if @body

  # root
  return User.current ? Template.render('main/index') : PromoCell.render(:index) unless @root_part

  # debug development routes
  if Lux.dev?
    for el in [ [:lux, LuxRenderCell], [:api, LuxApi] ]
      return el[1].resolve(*@path) if @root_part == el[0]
    end
  end

  # base root calls
  return PromoCell.resolve(@root_part) if [:set_password, :login, :css].index(@root_part)

  # application routes
  if [:link, :note, :bucket, :user].index(@root_part)
    return Lux.status :forbiden, 'Only for registred users' unless User.current
    
    return "Main::#{@root_part.to_s.classify}Cell".constantize.resolve(*@path)
  end

  Lux.status :not_found, "Page not found not route /#{@root_part}"
end

post '/api/*' do
  return LuxApi.resolve(*@path)
end

post '*' do
  Lux.status :forbiden, 'Request not allowed'
end