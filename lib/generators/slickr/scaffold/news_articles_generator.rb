require 'rails/generators/active_record'

module Slickr
  module Generators
    module Scaffold
      class NewsArticlesGenerator < ActiveRecord::Generators::Base
        source_root File.expand_path("./templates", __FILE__)
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
          template "config/locals/models/news_articles.en.yml", "config/locals/models/news_articles.en.yml"
          puts "Add translations"
        end

        def db_migrations
          migration_template "migrations/create_news_articles.rb", "db/migrate/create_slickr_pages.rb"
          puts "Database migrations added"
        end

        def news_articles_js
          template "javascripts/controllers/news_articles.js", "app/javascripts/controllers/news_articles.js"
          template "javascripts/news_articles.js", "app/javascripts/news_articles.js"
          puts "Add js"
        end

        def news_articles_views
          template "views/components/button/_button.html.erb", "app/views/components/button/_button.html.erb"
          template "views/components/button/button.js", "app/views/components/button/button.js"
          template "views/components/button/button.scss", "app/views/components/button/button.scss"
          template "views/components/button/button.story.html", "app/views/components/button/button.story.html"
          template "views/components/card/_card.html.erb", "app/views/components/card/_card.html.erb"
          template "views/components/card/card.scss", "app/views/components/card/card.scss"
          template "views/news_articles/filters/filters.html", "app/views/news_articles/filters/filters.html"
          template "views/news_articles/listing/listing.html", "app/views/news_articles/listing/listing.html"
          template "views/news_articles/_articles.html.erb", "app/views/news_articles/_articles.html.erb"
          template "views/news_articles/index.html.erb", "app/views/news_articles/index.html.erb"
          template "views/news_articles/index.js.erb", "app/views/news_articles/index.js.erb"
          template "views/news_articles/show.html.erb", "app/views/news_articles/show.html.erb"
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
      end
    end
  end
end
