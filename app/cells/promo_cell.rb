class PromoCell < LuxCell

  layout :main

  template :index, :css

  def login
    Page.status(401) if Page.request.path != '/login'
  end

end