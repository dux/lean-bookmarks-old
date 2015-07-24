# we need this for development fast code restart
  $LIVE_REQUIRE = {}
  $ENVIROMENT   = ENV['RAKE_ENV'].to_s[0,4] == 'prod' ? 'production' : 'development'

# if we have errors in module loading, try to load them one more time
  @module_error = []
      
  def lux_smart_require(name)
    file = "#{name}.rb"
    $LIVE_REQUIRE[file] = File.mtime(file).to_i
    # puts file.red
    require(file) rescue @module_error.push(file)
  end

  def lux_load_lib(name)
    if name.index('*')
      files = `find #{name.split('/*')[0]} | grep .rb`.split("\n").sort
      puts "* modules in #{name} - #{files.length} files".white
      for klass in files
        next unless klass.index('.rb')
        # puts "  - module #{klass}".white
        lux_smart_require klass.split('.rb')[0]
      end
    else
      puts "* module #{name}".white
      lux_smart_require name
    end
  end

# create modules for main cell directory
  for el in Dir.entries('./app/cells').reject{ |el| el[0,1]=='.'}
    eval "module #{el.classify}; end"
  end

# load all libs
  lux_load_lib './lux/lib/*'
  lux_load_lib './lux/plugins/*'
  lux_load_lib './lux/modules/*'
  lux_load_lib './lux/overload/*'
  lux_load_lib './app/*'
  lux_load_lib './config/*'

  @module_error.map { |lib| require lib } 
  @module_error = nil

# load Tilt parsers
  Tilt.register Tilt::ERBTemplate, 'erb'
  Tilt.register Haml::Engine, 'haml'

# reload code in development
  before do
    for file, mtime in $LIVE_REQUIRE
      next if mtime == File.mtime(file).to_i
      $LIVE_REQUIRE[file] = File.mtime(file).to_i
      puts "Live reload: #{file.red}"
      File.read(file).gsub(/class\s+([:\w]+)/) { load file }
    end
  end if Lux.dev?

# inform about enviroment
  puts "* #{Lux.dev? ? 'development'.green : 'production'.red } mode"

