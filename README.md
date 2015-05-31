# Lux / on sinatra

small sinatra and rails inspired framework


# Main API

## LuxCell

Cell is just a class with instance methods that retuns data or redirect to another page. It can act as Rails controler but offers more freedom.

### Things to remember

* we call methods in cells via class method like ```UserCell.render(:show, 2)``` and send method mane as symbol argument
* there are three basic MasterCell class methods
  * **get** - ```UserCell.get(:random)``` - returns generic data
  * **render** - ```UserCell.render(:show, 2)``` - renders page with layout
  * **part** - ```UserCell.part(:show, 2)``` - returns single template without layout


If you inherit from MasterCell you will have helper methods as render

    module Main
      class UserCell < MasterCell

		# in this example cell acts as router
		# aceepts arguments and behaves accordingly
        def self.router(*args)
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

    end



## Template class

Template instead of Cell renders only template without backend logic. It you need simple templates witout complex logic you can use Template class instead of Lux::Cell 

* ```Template.part('main/index', { foo:'bar' })``` renders single template './app/views/main/index.haml'
* ```Template.render('main/index', { foo:'bar' })``` renders single template with layout './app/views/main/layout.haml'


## LuxHelper

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
       
       

## Inflectors

All common Rails inflectors are included

* humanize
* constantize
* classify
* singularize
* camelize
* tableize

## Why?

There are just to many things I dont like about rails

* I hate rails routing, expetialy constrains and way that is handled.
* ther are no components in rails, at least not the easy way without hacking
* ther is no way to have generic routes and clean code at the same time
* ... and few other things



