require 'open3'

class Asset
  @@cache = {}

  attr_reader :file_public
  attr_reader :file_full

  def self.get_link(path)
    return path if path.index(/https?:/)

    asset = new(path, { :root=>Lux.root })

    if Lux.prod?
      if !@@cache[path] && File.exists?(asset.file_full)
        @@cache[path] ||= asset.browser_file
      end
      return @@cache[path] if @@cache[path]
    end

    asset.render_asset_file

    @@cache[path] = asset.browser_file
  end

  def self.css(href)
    %[<link href="#{get_link(href)}" rel="stylesheet" type="text/css">]
  end

  def self.js(src)
    %[<script src="#{get_link(src)}"></script>]
  end

  def self.jquery
    %[<script src="#{Lux.dev? ? '/jquery.js' : 'https://code.jquery.com/jquery-2.1.1.min.js'}"></script>]
  end

  def initialize(file, opts={})
    ext = file.split('.').reverse[0].to_sym

    unless [:js, :css, :coffee, :less, :scss, :sass, :haml, :coffe].index(ext)
      puts "Unsuported file type for Assets [#{file}]"
      exit
    end

    ext = [:js, :coffee].index(ext) ? :js : :css

    @opts = opts
    @opts[:root] ||= './'
    @opts[:cache] ||= "#{@opts[:root]}/.assets_cache"

    @file_in     =  file
    @file_public = "/assets/"+file.gsub('/','-').sub(/\.\w+/,'')+".#{ext}"
    @file_full   = "#{@opts[:root]}/public#{@file_public}"
    @file_assets = "#{@opts[:root]}/app/assets/#{@file_in}"
  end

  def browser_file
    "#{@file_public}?#{File.stat(@file_full).mtime.to_i}"
  end

  def render_asset_file
    Dir.mkdir(@opts[:cache]) unless Dir.exists?(@opts[:cache])
    Dir.mkdir("#{@opts[:root]}/public/assets") unless Dir.exists?("#{@opts[:root]}/public/assets")

    fill_source_files
    compile_source_files
    join_source_files_to_public_file
  end

  def run!(what, cache=nil)
    stdin, stdout, stderr, wait_thread = Open3.popen3(what)
    if err = stderr.gets
      File.unlink(cache) if File.exists?(cache)
      raise "Asset compile error\n\n#{what}\n\n#{err}"
    end
  end

  def fill_source_files
    @req_files = []

    raise "Asset.rb file does not exist!: #{@file_in}" unless File.exists?(@file_assets)

    for line in File.read(@file_assets).split("\n")
      elms = line.split(/\s+/)

      next unless ['//=','#='].index(elms[0])

      directive, source = elms[1], elms[2]
      to_load = (Pathname.new(@file_assets).dirname + source).to_s

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

    @req_files.push @file_assets
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
            run! "scss -t compact '#{file}' --cache-location '.assets_cache' '#{cache}'", cache
          end
        end

        @compiled_files.push(cache)
      else
        if !File.exist?(cache) || File.mtime(cache) < File.mtime(file)
          measure file do
            case ext
              when :less
                run! "lessc '#{file}' > '#{cache}'", cache
              when :haml
                run! "haml '#{file}' > '#{cache}'", cache
              when :coffee
                run! "coffee -p -c '#{file}' > '#{cache}'", cache
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

    File.open(@file_full, 'w') { |f| f.write(public_data.join("\n")) } 

    if Lux.prod?
      run! "minify --no-comments -o '#{@file_full}' '#{@file_full}'", @file_full
    end
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