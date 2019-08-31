require 'rails/generators/active_record'

module Slickr
  module Generators
    module Scaffold
      class NewsArticlesGenerator < ActiveRecord::Generators::Base
        source_root File.expand_path("../templates", __FILE__)
        desc "Running Slickr scaffold for News Articles"
        argument :name, type: :string, default: "news_articles"

        def news_articles_model
          template "models/news_article.rb", "app/models/news_article.rb"
          puts "Add model"
        end

        def news_articles_admin
          template "admin/news_articles.rb", "app/admin/news_articles.rb"
          puts "Add admin interface"
        end

        def news_articles_controller
          template "controllers/news_articles_controller.rb", "app/controllers/news_articles_controller.rb"
          puts "Add controller"
        end

        def news_articles_translations
          template "config/locales/models/news_articles.en.yml", "config/locales/models/news_articles.en.yml"
          puts "Add translations"
        end

        def db_migrations
          migration_template "migrations/create_news_articles.rb", "db/migrate/create_news_articles.rb"
          puts "Database migrations added"
        end

        def news_articles_js
          template "javascript/controllers/news_articles.js", "app/javascript/application/javascripts/controllers/news_articles.js"
          template "javascript/news_articles.js", "app/javascript/news_articles.js"
          puts "Add js"
        end

        def news_articles_views
          directory "views", "app/views/"
          puts "Add views"
        end

        def news_articles_tests
          template "test/controllers/news_articles_controller_test.rb", "test/controllers/news_articles_controller_test.rb"
          template "test/fixtures/news_articles.yml", "test/fixtures/news_articles.yml"
          template "test/models/news_articles_test.rb", "test/models/news_articles_test.rb"
          puts "Add tests"
        end

        def news_articles_routes
          route "resources :news_articles, only: %i[index show]"
          puts "Added news articles routes"
        end

        def news_articles_packages
          run "yarn add axios"
          run "yarn add querystring"
          puts "Added news articles packages"
        end
      end
    end
  end
end
