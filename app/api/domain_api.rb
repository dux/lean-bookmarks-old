class DomainApi < LuxApi

  # def toggle_article
  #   @domain = Domain.search_or_new( created_by:User.current.id, name:params[:domain] )
  #   if @domain.is_article
  #     @domain.is_article = false
  #     respond 'Domain is not article domain'
  # else
  #     @domain.is_article = true
  #     respond 'Article domain set'
  #   end
  #   @domain.save!
  # end

  def set_domain_data
    desc = params[:description]
    d = Domain.get(params[:d])    
    if desc
      d.description = desc
      d.save!
      return 'Domain data saved'
    else
      d.destroy! if d.id
      return 'Domain data removed'
    end
  end
    
end