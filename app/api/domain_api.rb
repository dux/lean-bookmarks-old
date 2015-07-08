class DomainApi < LuxApi

  def toggle_article
    @domain = Domain.search_or_new( created_by:User.current.id, name:params[:domain] )
    if @domain.is_article
      @domain.is_article = false
      respond 'Domain is not article domain'
  else
      @domain.is_article = true
      respond 'Article domain set'
    end
    @domain.save!
  end

end