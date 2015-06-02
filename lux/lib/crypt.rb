require 'openssl'
require "base64"
require 'digest/md5'

class Crypt
  def self.uid
    Crypt.md5 "#{DateTime.now.to_i}-#{rand()}"    
  end

  def self.sha1(str)
    Digest::SHA1.hexdigest str.to_s+Crypt.secret
  end

  def self.md5(str)
    Digest::MD5.hexdigest str.to_s+Crypt.secret
  end

  def self.cipher(mode, data, key='')
    cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc').send(mode)
    cipher.key = Digest::SHA512.digest(Crypt.secret+key)
    cipher.update(data.to_s) << cipher.final
  end

  def self.encrypt(data,key='')
    Base32.encode(cipher(:encrypt, data, key)).chomp
  end

  def self.decrypt(text, key='')
    cipher(:decrypt, Base32.decode(text), key)
  end

  def self.secret
    'mentions12345654321!'
  end

  def self.base64(str)
    Base64.encode64(str)
  end
end
