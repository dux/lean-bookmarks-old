module StringBase
  KEYS = 'bcdghjklmnpqrstvwxyz'

  def self.encode( value )
    value = value * 99
    ring = Hash[KEYS.chars.map.with_index.to_a.map(&:reverse)]
    base = KEYS.length
    result = []
    until value == 0
      result << ring[ value % base ]
      value /= base
    end
    result.reverse.join
  end

  def self.decode( string )
    ring = Hash[KEYS.chars.map.with_index.to_a]
    base = KEYS.length
    ret = string.reverse.chars.map.with_index.inject(0) do |sum,(char,i)|
      sum + ring[char] * (base**i)
    end
    raise 'Invalid decode base' if ret%99>0
    ret/99
  end
end