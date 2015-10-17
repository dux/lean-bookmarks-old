class AdminCell < LuxCell

  def self.admin_on 
    [:links, :buckets, :notes, :users]
  end

  def self.resolve(path)
    ap path

    return render(:main_index) unless path.first
    return render(:index, path[0]) unless path[1]
    return render(:show, path[0], path[1], path[2])
  end

  def main_index

  end

  def index(object)
    @template = "admin/#{object}/index"    
  end

  def show(object, id, tpl=nil)
    tpl ||= :show
    eval %[
      @#{object.singularize} = #{object.singularize.classify}.unscoped.find(id)
    ]    
    @template = "admin/#{object.pluralize}/#{tpl}"
  end

end
