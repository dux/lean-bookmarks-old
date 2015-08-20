class TrueClass

  # true.resolve?(1) -> true
  # true.resolve?(false) -> false
  # true.resolve?(true) -> true
  # true.resolve?(nil) -> false
  # true.resolve?('miki') -> true
  # true.resolve?(->{ 1 == 2 }) -> false
  def resolve?(rule=nil)
    return false unless rule

    if rule.kind_of?(Proc)
      return true if rule.call()
    elsif rule.kind_of?(TrueClass)
      return true
    else
      return true if rule
    end

    false
  end

end