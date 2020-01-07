require 'rails/generators/active_record'

module Slickr
  module Generators
    module Scaffold
      class LocationsGenerator < ActiveRecord::Generators::Base
        source_root File.expand_path("../templates", __FILE__)
        desc "Running Slickr scaffold for Locations"
        argument :name, type: :string, default: "locations"

        def location_model
          template "models/location.rb", "app/models/location.rb"
          puts "Add model"
        end

        def locations_admin
          template "admin/locations.rb", "app/admin/locations.rb"
          puts "Add admin interface"
        end

        def locations_gem
          gem 'geokit-rails'
        end

        def locations_initializer
          template "config/initializers/geokit_config.rb", "config/initializers/geokit_config.rb"
          puts "Add translations"
        end

        def locations_translations
          template "config/locales/models/locations.en.yml", "config/locales/models/locations.en.yml"
          puts "Add translations"
        end

        def db_migrations
          migration_template "migrations/create_locations.rb", "db/migrate/create_locations.rb"
          puts "Database migrations added"
        end

        def peole_views
          # directory "views", "app/views/"
          # puts "Add views"
        end

        def locations_tests
          # template "test/controllers/locations_controller_test.rb", "test/controllers/locations_controller_test.rb"
          # template "test/fixtures/locations.yml", "test/fixtures/locations.yml"
          # template "test/models/locations_test.rb", "test/models/locations_test.rb"
          # puts "Add tests"
        end

        def locations_routes
          # route "resources :locations, only: %i[index show], path: 'locations'"
          # puts "Added locations routes"
        end

        def locations_packages
          # puts "Added news articles packages"
        end
      end
    end
  end
end
