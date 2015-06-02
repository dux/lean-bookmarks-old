def load_lib(name)
  if name.index('*')
    files = `find #{name.split('/*')[0]} | grep .rb`.split("\n").sort
    puts "* modules in #{name} - #{files.length} files".white
    for klass in files
      require klass.split('.rb')[0]
    end
  else
    puts "* module #{name}".white
    require name
  end
end

load_lib './lux/lib/*'
load_lib './lux/modules/*'
load_lib './lux/overload/*'
load_lib './app/*'
load_lib './lux/lux_config'
load_lib './config/*'

