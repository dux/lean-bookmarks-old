require './lux/init'

get '*' do
  # @body can be defined in before filter
  return @body if @body

  # root
  unless @root_part
    return User.current ? Template.render('main/index') : PromoCell.render(:index)
  end

  # debug routes
  if Lux.dev?
    for el in [
      [:lux,LuxRenderCell],
      [:api, LuxApi]
      ]
      return el[1].raw(*@path) if @root_part == el[0]
    end
  end

  # base root calls
  return PromoCell.raw(@root_part) if [:set_password, :login, :css].index(@root_part)

  # application routes
  for el in [
    [:link, Main::LinkCell],
    [:note, Main::NoteCell],
    [:bucket, Main::BucketCell],
    [:user, Main::UserCell],
    [:action, Main::ActionCell]
    ]
    if @root_part == el[0]
      return @msg if (@msg = App.init_for_users)
      @path[0] = StringBase.decode(@path[0]) rescue @path[0]
      return el[1].send(:raw, *@path) 
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