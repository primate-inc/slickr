require 'rails/generators/active_record'

module Slickr
  module Generators
    module Scaffold
      class EventsGenerator < ActiveRecord::Generators::Base
        source_root File.expand_path("../templates", __FILE__)
        desc "Running Slickr scaffold for Events"
        argument :name, type: :string, default: "events"

        def events_model
          template "models/event.rb", "app/models/event.rb"
          puts "Add model"
        end

        def events_admin
          template "admin/events.rb", "app/admin/events.rb"
          puts "Add admin interface"
        end

        def events_controller
          template "controllers/events_controller.rb", "app/controllers/events_controller.rb"
          puts "Add controller"
        end

        def events_translations
          template "config/locales/models/events.en.yml", "config/locales/models/events.en.yml"
          puts "Add translations"
        end

        def db_migrations
          migration_template "migrations/create_events.rb", "db/migrate/create_events.rb"
          puts "Database migrations added"
        end

        def events_js
          template "javascript/controllers/events_controller.js", "app/javascript/application/javascripts/controllers/events_controller.js"
          template "javascript/events.js", "app/javascript/events.js"
          puts "Add js"
        end

        def events_views
          directory "views", "app/views/"
          puts "Add views"
        end

        def events_tests
          template "test/controllers/events_controller_test.rb", "test/controllers/events_controller_test.rb"
          template "test/fixtures/events.yml", "test/fixtures/events.yml"
          template "test/models/events_test.rb", "test/models/events_test.rb"
          puts "Add tests"
        end

        def events_routes
          route "resources :events, only: %i[index show], path: 'events'"
          puts "Added event routes"
        end

        def events_packages
          run "yarn add axios"
          run "yarn add querystring"
          puts "Added event packages"
        end
      end
    end
  end
end
