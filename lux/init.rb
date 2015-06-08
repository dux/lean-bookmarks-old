def load_lib(name)
  if name.index('*')
    files = `find #{name.split('/*')[0]} | grep .rb`.split("\n").sort
    puts "* modules in #{name} - #{files.length} files".white
    for klass in files
      next unless klass.index('.rb')
      # puts "  - module #{klass}".white
      require klass.split('.rb')[0]
    end
  else
    puts "* module #{name}".white
    require name
  end
end

# create modules for main cell directory
for el in Dir.entries('./app/cells').reject{ |el| el[0,1]=='.'}
  eval "module #{el.classify}; end"
end

load_lib './lux/lib/*'
load_lib './lux/modules/*'
load_lib './lux/overload/*'
load_lib './app/*'
load_lib './config/*'

Tilt.register Tilt::ERBTemplate, 'erb'
Tilt.register Haml::Engine, 'haml'

