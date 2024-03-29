# Lux / on sinatra

small sinatra and rails inspired framework


# Main API

## Router

There is no router in Lux, requests are handled Sinatra style. 

Here is example that 

* captures all GET requests
* POST request to '/api' are handled by API controller
* all other POST posts are not allowed

      get '*' do
        # @body can be defined in before filter
        return @body if @body

        # /
        return Template.render('main/index') unless @root_part

        # application routes
        case @root_part.singularize.to_sym
          when :test
            Page.flash :info, 'all ok'
            return redirect '/'
          when :user
            return Main::UserCell.resolve(@path)
          when :action
            return Main::ActionCell.resolve(@first_part)
          when :grid
            return Template.part('grid')
          else
            Page.status :not_found, "Unknown route for path /#{@root_part}"
        end

        # debug routes
        if Page.dev?
          case @root_part.singularize.to_sym
            when :lux
              return LuxRenderCell.dev_row(*@path)
            when :api
              return LuxApi.resolve(*@path)
          end
        end

        Page.status :not_found, "Page not found not route /#{@root_part}"
      end

      post '/api/*' do
        return LuxApi.resolve(*@path)
      end

      post '*' do
        Page.status :forbiden, 'Request not allowed'
      end

## LuxCell

Cell is just a class with instance methods that retuns data or redirect to another page. It can act as Rails controler but offers more freedom.

### Things to remember

* we call methods in cells via class method like ```UserCell.render(:show, 2)``` and send method mane as symbol argument
* there are three basic MasterCell class methods
  * **resolve** - ```UserCell.get(:random)``` - returns generic data
  * **render** - ```UserCell.render(:show, 2)``` - renders page with layout
  * **part** - ```UserCell.part(:show, 2)``` - returns single template without layout
* inside Cell class you can
  * define **before** filters as in Rails
  * define **layout** as in Rails (but withot bugs)
  * quick define index methods with **template**


If you inherit from MasterCell you will have helper methods as render

    class Main::UserCell < MasterCell

      template :login, :profile

      before do
        raise 'Only for registred users' unless User.current
      end

	  # in this example cell acts as router
	  # aceepts arguments and behaves accordingly
	  def self.resolve(*args)
        what = args.first

	    # /users -> UserCell.render(:index)
        return render :index unless what

	    # /user/random -> UserCell.get(:random)
	    return get :random if what == 'random'

	    # /user/2 -> UserCell.render(:show, 2)
        return render :show, what.to_i
      end

      def show(id)
        @user = User.find(id)
      end

      def random
        # in cells Sinatra API is exposed via [sinatra] method
        sinatra.headers({ 'X-Test'=>"123456789" })
        
        id = (1..10).to_a.sample # get radom user id
		render(:show, id)        # execute /user/2 without redirect
      end

      # same thing as
      # Template.render('main/users/index', { :@users=>User.all })
      def index
        @users = User.all
      end

    end



### Inside (HAML) templates

#### render with block given

renders code part as micro layout. same thing as render :layout in rails

we are inside /app/views/main/users/index.haml so :show is translated to "main/users/show"

    = render :show, :@user=>user do
      ...
    = render 'main/users/show', :@user=>user do
      ...

#### render without block

renders code part inside /app/views/main/users/index.haml 

    = render :show, :@user=>user
    = render 'main/users/show', :@user=>user


#### direct render cell

renders code part inside /app/views/main/users/index.haml

    = Main::UserCell.part(:show, user.id)
    = cell(:user, :show, user.id)



### Template class

Template instead of Cell renders only template without backend logic. It you need simple templates witout complex logic you can use Template class instead of Lux::Cell 

* ```Template.part('main/index', { foo:'bar' })``` renders single template './app/views/main/index.haml'
* ```Template.render('main/index', { foo:'bar', :@baz=>123 })``` renders single template with layout './app/views/main/layout.haml'


### LuxHelper

Same thing as Rails helpers. By default loads nothing and you have to defined in each cell what you want included in templates

Onl built in helper is :rails helper that adds common rails methods

How to use:

    class BlogCell
       helper :rails, :extra
       
       ...
       
Will search for modules RailsHelper, ExtraHelper and load them. BlogHelper will be loaded by default if exists.

DefaultHelper is loaded by default for all cells. If you want :rails helpers in all templates across application write DefaultTemplate and incude Rails helper like this 

    module DefaultHelper
       include RailsHelper
    end

after that RailsHelper will be included by default
       
 
## Mailer

Mailers have to inherit from LuxMailer

#### sugessted usage

    Mailer.deliver(:confirm_email, 'rejotl@gmailcom')
    Mailer.render(:confirm_email, 'rejotl@gmailcom')

	# natively works like
    Mailer.prepare(:confirm_email, 'rejotl@gmailcom').deliver
    Mailer.prepare(:confirm_email, 'rejotl@gmailcom').body

    # Rails mode via method missing is also suported
    Mailer.confirm_email('rejotl@gmailcom').deliver
    Mailer.confirm_email('rejotl@gmailcom').body


This all will deliver mail that has template in /app/views/mailer/confim_email
 
#### Sample mailer class 

That will create default @from adress and redirect all mails to develper address in development mode. 
No need for mail cachers here.

    class Mailer < LuxMailer
      before do
        @from = 'lux@luxlib.com'
      end

      after do
        @subject = "[For: #{@to}] #{@subject}"
        @to = 'reic.dino@gmail.com'
      end if Page.dev?

      def confirm_email(email)
        @subject = 'Wellcom to Lux!'
        @to = email
        @link = "#{Page.host}/action/confirm_email?data=#{Crypt.encrypt(@to)}"
      end

      def self.confirm_email_preview
        confirm_email('rejotl@gmailcom')
      end
    end
    

## API

API has to inherit from LuxApi and can be writter in three ways as shown below

    class UserApi < LuxApi

      # action with options in block
      # only possible way if you want to params cecking
      action :show do
        name 'Show single user based on email'
        params :email, :email, :req
        lambda do
          User.where(email:params[:email]).first.attributes
        end
      end

	  # if you dont need options you can use inline_action shorthand
      inline_action :show, 'Show single user based on email' do
        User.where(email:params[:email]).first.attributes
      end

	  # without name and optsion
      def show
        User.where(email:params[:email]).first.attributes
      end

    end

Show method on user can be accesible via /api/users/show or /api/v1/users/show pr whatever
    

## Flash

	Lux.flash :info, 'Page loaded'
	Lux.flash_now :info, 'Page loaded'
	

## Inflectors

All common Rails inflectors are included

* humanize
* constantize
* classify
* singularize
* camelize
* tableize
* to_sentence


## Why?

There are just to many things I dont like about rails

* I hate rails routing, expetialy constrains and way that is handled.
* ther are no components in rails, at least not the easy way without hacking
* ther is no way to have generic routes and clean code at the same time
* ... and few other things



