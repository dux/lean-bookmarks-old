class Asset

  attr_accessor :public_file

  def self.get_link(path)
    return path if path.index(/https?:/)
    ext = path.split('.').last.to_sym
    path = "#{Lux.root}/app/assets/#{path}".gsub('//','/')
    ass = new(path, { :root=>Lux.root })
    ass.public_file
  end

  def self.css(href)
    %[<link href="#{get_link(href)}" rel="stylesheet" type="text/css">]
  end

  def self.js(src)
    %[<script src="#{get_link(src)}"></script>]
  end

  def self.jquery
    js 'https://code.jquery.com/jquery-2.1.1.min.js'
  end

  def initialize(file, opts={})
    ext = file.split('.').reverse[0].to_sym
    unless [:js, :css, :coffee, :less, :scss, :sass, :haml, :coffe].index(ext)
      puts "Unsuported file type #{file}"
      exit
    end

    @file = file

    @dir = Pathname.new(file).dirname
    @opts = opts
    @opts[:root] ||= './'
    @opts[:cache] ||= "#{@opts[:root]}/.assets_cache"
    Dir.mkdir(@opts[:cache]) unless Dir.exists?(@opts[:cache])
    Dir.mkdir("#{@opts[:root]}/public/assets") unless Dir.exists?("#{@opts[:root]}/public/assets")

    fill_source_files
    compile_source_files
    join_source_files_to_public_file
  end

  def fill_source_files
    @req_files = []

    raise "Asset.rb file does not exist!: #{@file}" unless File.exists?(@file)

    for line in File.read(@file).split("\n")
      elms = line.split(/\s+/)

      next unless ['//=','#='].index(elms[0])

      directive, source = elms[1], elms[2]
      to_load = (@dir + source).to_s

      if directive == 'require_tree' || source.index('*')
        to_load += '/*' unless to_load.index('*')
        files = Dir[to_load.sub(/\/+/,'/')].sort
        exit puts "No files in #{source}" unless files.length > 0
        for file in files.sort
          next if file.index('!')
          @req_files.push(file)
        end
      else
        @req_files.push(to_load)
      end
    end

    for file in @req_files
      raise "Asset.rb: File '#{file}' linked from '#{@file}' does not exist!" unless File.exists?(file)
    end

    @req_files.push @file
  end

  def compile_source_files
    @compiled_files = []

    for file in @req_files
      ext   = file.split('.').last.to_sym
      cache = cache_file(file)

      if [:js, :css].index(ext)
        @compiled_files.push(file)
      elsif [:scss, :sass].index(ext)
        do_compile = false

        if File.exists?("#{cache}.map")
          hash = JSON.parse File.read("#{cache}.map")
          files = hash['sources'].map{ |el| el.sub(/^\.\./,'.') } + [file]

          cache_time = File.mtime(cache)
          
          for el in files
            next if do_compile
            do_compile = true if !File.exist?(el) || cache_time < File.mtime(el)
          end
        else
          do_compile = true        
        end

        if do_compile
          measure file do
            `scss -t compact '#{file}' --cache-location '.assets_cache' '#{cache}'`
          end
        end

        @compiled_files.push(cache)
      else
        if !File.exist?(cache) || File.mtime(cache) < File.mtime(file)
          measure file do
            case ext
              when :less
                  `lessc '#{file}' > '#{cache}'`
              when :haml
                `haml '#{file}' > '#{cache}'`
              when :coffee
                `coffee -p -c '#{file}' > '#{cache}'`;
            end
          end
        end

        @compiled_files.push(cache)
      end
    end
  end

  def join_source_files_to_public_file
    src_files = []
    public_data = []
    @compiled_files.each_with_index do |file, i|
      src = local(@req_files[i])
      src_files.push src
      public_data.push "/* Asset file: #{src} */"
      public_data.push File.read(file)
      public_data.push ''
    end

    public_data.unshift ''
    public_data.unshift %[/* Compiled and copied assets files in use: \n#{src_files.map{ |el| " - #{el}"}.join("\n")}\n*/]

    @public_file = "/assets/"+local(@file).gsub('/','-').sub(/\.\w+/,'')+".#{cache_file(@file, :ext)}"

    File.open("#{@opts[:root]}/public#{public_file}", 'w') { |f| f.write(public_data.join("\n")) } 
  end

  def cache_file(original_file, get_only_ext=false)
    file = local(original_file)
    file.sub!(/\.(\w+)$/,'')

    original_ext = $1.to_sym
    ext = [:js, :coffee].index(original_ext) ? :js : :css

    return ext if get_only_ext

    file.sub!(/\.\w+$/,'')

    "#{@opts[:cache]}/#{file.gsub(/\/+/,'-')}.#{ext}"
  end

  def measure(file)
    time = Time.new
    yield
    time = (Time.new - time).to_i
    puts "File #{local(file).yellow} compiled in #{time.to_s.sub(/(\d)(\d{3})$/, '\1.\2').yellow} ms"
  end

  def local(file)
    file.split('/assets/',2)[1]
  end

end