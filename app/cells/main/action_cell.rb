# # usage
# when :action
#   return Main::ActionCell.get(@action_name)
# returns error page if action is not found
# executes action if found

class Main::ActionCell < LuxCell

  def self.resolve(action_name)
    return Error.not_found "Action <b>#{action_name}</b> not found" unless new.respond_to?(action_name)

    begin
      new.send(action_name)
    rescue
      Page.status :error, "Action <b>#{action_name}</b>: #{$!.message}"
    end
  end
  
  def confirm_email
    @email = Crypt.decrypt(params[:data])

    template #:confirm_email

    # do shit

    # Page.flash :info, 'All ok'
    # Page.redirect_to('/login')
    # Page.sinatra.redirect('/login')
  end

  def unsubscribe
    'to do'
  end

end
