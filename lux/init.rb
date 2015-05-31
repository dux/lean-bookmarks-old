def load_lib(name)
  if name.index('*')
    files = Dir[name]
    puts " #{files.length} files in dir #{name}".green
    for file in Dir[name]
      load_lib file.split('.rb')[0]
    end
    return
  end

  puts "Loading module'#{name}'".green
  require name
  also_reload "#{name}.rb" if development?
end

load_lib './lux/lux'
load_lib './lux/modules/*'
load_lib './lux/overload/*'
load_lib './config/*'

for klass in `find ./app | grep .rb`.split("\n").sort
  load_lib klass.split('.rb')[0]
end
