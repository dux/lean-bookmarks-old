# Example
#
# ApiTesting.new( :url=>'http://localhost' ).run! do
#   SessionTest.new( :email=>'jozo@bozo1.com' ).run!
#   MeetingTest.new( :user=>1 ).run! # put user if 100000 for error
# end

require 'rest_client'
require 'pp'
require 'json'
require 'colorize'
require 'date'
require 'nokogiri'
require 'cgi'

# base class for api testing

class LuxTest

  def initialize(opts={})
    @@url = opts[:url] || 'http://localhost:3000'
    @@count = 0
    @@error_count = 0
    @@time = 0
    self
  end

  # wrapper for running tests, gives speed and error report
  def run!
    time = Time.now
    yield
    time = ((Time.now-time)*1000).round
      
    print "\n  -\n"
    
    if @@error_count == 0
      green "All tests finished in #{time} ms with no errors"
    else
      red "All tests finished in #{time} ms with #{@@error_count} errors"
    end
  end

  # put test title, extract class name and yiled if block given
  def test(text)
    print "\n#{@@count += 1}. #{self.class.name.sub(/Test/,'')}: #{text.chomp}".ljust(50).blue
    begin
      yield if block_given?
    rescue
      @@error_count += 1
      puts $!.message.red
    end
  end

  # format text n colors
  def green(text)
    puts "   #{text.chomp}".green
  end

  def red(text)
    puts "   #{text.chomp}".red
  end

  # execute rails /api calls and return response as Hash
  def api(url, opts={})
    url_base = "#{@@url}/api/#{url}"
    puts "  API: #{url_base}?" + opts.map{|k,v|"#{k}=#{v}"}.join('&')
    opts[:local_testing] = 1
    time = Time.now

    curl = "#{url_base}?" + opts.map{|k,v|"#{k}=#{URI.escape(v.to_s)}"}.join('&')

    begin
      # data = `curl -s '#{curl}'` # RestClient.get url_base, params:opts
      data = RestClient.get url_base, params:opts
      if data == ''
        print red 'No response from server'
      end
    rescue 
      red $!.message + ', probbably site not exists'
      exit
    end
    data = JSON data
    data['ms'] = ((Time.now - time)*1000).round
    data
  end

  # excepts api response, exptects response with errors
  def assert_error(data)
    if data['error']
      green "OK [#{data['ms']} ms]: #{data['error']}"
      return true
    else
      red "ERROR [#{data['ms']} ms]: #{data}"
      @@error_count += 1
      return false
    end
  end

  # excepts api response, exptects valid response
  def assert_ok(data)
    if data['error']
      red "ERROR [#{data['ms']} ms]: #{data.delete('error')}\n  #{data}"
      @@error_count += 1
      return false
    else
      green "OK [#{data['ms']} ms]: #{data['message']}"
      return true
    end
  end

  def assert_exists(data, search)
    if data.index(search)
      green "FOUND: #{search}"  
    else
      puts red "NOT FOUND: #{search}"
      @@error_count += 1
      return false
    end
  end

  # extracts all links from html document, usefu for getting links from emails
  def get_all_links(data)
    doc = Nokogiri::HTML data
    links = []
    doc.css('a').each do |link|
      links << link['href']
    end       
    links   
 end

 # local helper method, finds link with certain mask and returns it
 def link_from_email(data, test_string_mask)
    for link in get_all_links data['email_data']
      return link if link.index test_string_mask
    end
    false
 end

 def http_get(url, par={})
   puts "   HTTP: #{@@url}#{url}?#{par.map{|k,v|"#{k}=#{v}"}.join('&')}".sub(/\?$/,'')
   RestClient.get "#{@@url}#{url}", :params=>par
 end

end
