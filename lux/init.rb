# we need this for development fast code restart
  $LIVE_REQUIRE = {}
  
  def smart_require(name)
    file = "#{name}.rb"
    $LIVE_REQUIRE[file] = File.mtime(file).to_i
    # puts file.red
    require file
  end

  def load_lib(name)
    if name.index('*')
      files = `find #{name.split('/*')[0]} | grep .rb`.split("\n").sort
      puts "* modules in #{name} - #{files.length} files".white
      for klass in files
        next unless klass.index('.rb')
        # puts "  - module #{klass}".white
        smart_require klass.split('.rb')[0]
      end
    else
      puts "* module #{name}".white
      smart_require name
    end
  end

# create modules for main cell directory
  for el in Dir.entries('./app/cells').reject{ |el| el[0,1]=='.'}
    eval "module #{el.classify}; end"
  end

# load all libs
  load_lib './lux/lib/*'
  load_lib './lux/plugins/*'
  load_lib './lux/modules/*'
  load_lib './lux/overload/*'
  load_lib './app/*'
  load_lib './config/*'

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

# Haml::Template.options[:ugly] = true