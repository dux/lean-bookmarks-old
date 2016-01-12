module Validate
  extend self

  def email(email)
    raise 'Email must have 8 characters at least' unless email.to_s.length > 7
    raise 'Email is missing @' unless email.include?('@')
    raise 'Email is missing valid domain' unless email =~ /\.\w{2,4}$/
    raise 'Bad email format' unless email =~ /^[\w_\-\.]+\@[\w_\-\.]+$/i
    true
  end

  def email!(email=nil)
    raise 'No email defined' unless email
    email(email)
  end

  def url(url)
    raise "Not valid URL #{url}" unless url =~ /https?:\/\/\w+/
    true
  end

  def check_oib(oib) # iso 7064 - module 10,11
    oib = oib.to_s
    raise "OIB nije definiran" unless oib.to_s.present?
    raise "OIB nije sastavljen od brojeva" if oib =~ /[^\d]/
    raise "OIB mora imati točno 11 znamenki, vaš ima #{oib.to_s.length}" if oib.to_s.length != 11

    s = 10
    oib = oib.to_s.split('').map(&:to_i)
    for el in 0..9
      s = (oib[el]+s)%10
      s = s==0 ? 10 : s
      s = (s*2)%11
    end
    s = s==1 ? 0 : 11-s
    return true if oib[10] == s
    raise "OIB nije ispravan"
  end

  def test(method, what)
    Thread.current[:validate_error] = nil
    begin
      send method, what
    rescue
      Thread.current[:validate_error] = $!.message
      false
    end
  end

  def last_error
    Thread.current[:validate_error]
  end

end
