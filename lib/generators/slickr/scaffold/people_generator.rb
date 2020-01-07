require 'rails/generators/active_record'

module Slickr
  module Generators
    module Scaffold
      class PeopleGenerator < ActiveRecord::Generators::Base
        source_root File.expand_path("../templates", __FILE__)
        desc "Running Slickr scaffold for People"
        argument :name, type: :string, default: "people"

        def person_model
          template "models/person.rb", "app/models/person.rb"
          puts "Add model"
        end

        def people_admin
          template "admin/people.rb", "app/admin/people.rb"
          puts "Add admin interface"
        end

        def people_controller
          template "controllers/people_controller.rb", "app/controllers/people_controller.rb"
          puts "Add controller"
        end

        def people_translations
          template "config/locales/models/people.en.yml", "config/locales/models/people.en.yml"
          puts "Add translations"
        end

        def db_migrations
          migration_template "migrations/create_people.rb", "db/migrate/create_people.rb"
          puts "Database migrations added"
        end

        def peole_views
          directory "views", "app/views/"
          puts "Add views"
        end

        def people_tests
          template "test/controllers/people_controller_test.rb", "test/controllers/people_controller_test.rb"
          template "test/fixtures/people.yml", "test/fixtures/people.yml"
          template "test/models/people_test.rb", "test/models/people_test.rb"
          puts "Add tests"
        end

        def people_routes
          route "resources :people, only: %i[index show], path: 'people'"
          puts "Added people routes"
        end

        def people_packages
          # puts "Added news articles packages"
        end
      end
    end
  end
end
