require 'active_support/concern'

module LocalizationPlugin

  module Controller
    extend ActiveSupport::Concern

    included do
      before_filter :set_request_locale
    end

    def set_request_locale
      I18n.default_locale ||= I18n.available_locales[0]
      if params[:locale]
        if I18n.available_locales.index(params[:locale].to_sym)
          session[:locale] = params[:locale]
        else
          avail = I18n.available_locales.map{|el| %[<a href="#{request.path.sub(/\w+/,el.to_s)}">#{el}</a>] }
          page_error 404, "Locale &quot;#{params[:locale]}&quot; is not supported, try with #{avail.to_sentence.sub(/\sand\s/,' or ')}"
        end
      else
        browser_locale = User.request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first.to_sym rescue I18n.default_locale
        session[:locale] = browser_locale if I18n.available_locales.include?(browser_locale)
      end
      I18n.locale = session[:locale] || I18n.default_locale

      if !['api','admin'].index(request.path.split('/')[1]) && !request.xhr? && ! params[:locale]
        redirect_to("/#{I18n.locale}#{request.path}#{request.query_string.present? ? '?' : ''}#{request.query_string}".sub(/\/$/,''), status: 301)
      end
    end
  end

  module Model
    extend ActiveSupport::Concern

    included do
      def self.multilang_on(*args)
        for field in args
          eval %[def #{field}
            hash = JSON.parse(self[:#{field}]) rescue nil
            return self[:#{field}] if self[:#{field}].present? && !hash
            hash ||= {}
            hash[I18n.locale.to_s].to_s.or('?'+hash.values[0].to_s)
          end

          def #{field}=(data)
            hash = JSON.parse(self[:#{field}]) rescue {}
            hash[I18n.locale.to_s] = data
            self[:#{field}] = hash.to_json
            data
          end]

          for lang in I18n.available_locales
            eval %[def #{field}_#{lang}
              hash = JSON.parse(self[:#{field}]) rescue {}
              hash['#{lang}'].to_s.or('?'+hash.values[0].to_s)
            end

            def #{field}_#{lang}=(data)
              return data if data[0,1] == '?'
              hash = JSON.parse(self[:#{field}]) rescue {}
              hash['#{lang}'] = data
              self[:#{field}] = hash.to_json
              data
            end]
          end
        end
      end
    end
  end
end