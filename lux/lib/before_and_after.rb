class BeforeAndAfter

  def initialize
    @bef_and_aft = {}
  end

  def add(what, &block)
    @bef_and_aft[what] ||= []
    @bef_and_aft[what].push(block)
  end

  def exec(what, obj)
    for m in @bef_and_aft[what]
      obj.instance_exec(&m)
    end
  end

end
