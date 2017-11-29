require 'rails/generators/active_record'

module Slickr
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "Running Slickr generators"
      argument :name, type: :string, default: "application"

      def no_blank_slate
        template "active_admin_no_blank_slate.rb", "config/initializers/active_admin_no_blank_slate.rb"

        puts "No blank slate for Slickr images"
      end

      def slickr_yml
        template "slickr.yml", "config/slickr.yml"

        puts "Slickr yml for webpacker"
      end

      def extend_webpack_environment
        insert_after_line = "const { environment } = require('@rails/webpacker')"
        dest_file = "config/webpack/environment.js"
        existing_content = File.read(dest_file)
        new_content = File.read(File.join(File.dirname(__FILE__), '/templates/environment.js'))

        unless existing_content.include? new_content
          gsub_file(dest_file, insert_after_line) do |match|
            "#{match}\n#{new_content}"
          end

          puts "Extended webpacker environment to get packs from Slickr engine"
        else
          puts "Webpacker environment already extended"
        end
      end

      def alter_other_webpack_files
        replace_line = "module.exports = environment.toWebpackConfig()"
        dev_dest_file = "config/webpack/development.js"
        pro_dest_file = "config/webpack/production.js"
        test_dest_file = "config/webpack/test.js"
        dev_existing_content = File.read(dev_dest_file)
        pro_existing_content = File.read(pro_dest_file)
        test_existing_content = File.read(test_dest_file)
        new_content = "module.exports = environment.toWebpackConfigForRailsEngine()"

        unless dev_existing_content.include? new_content
          gsub_file(dev_dest_file, replace_line) do |match|
            "#{new_content}"
          end

          puts "Altered webpack development.js"
        else
          puts "development.js already altered"
        end

        unless pro_existing_content.include? new_content
          gsub_file(pro_dest_file, replace_line) do |match|
            "#{new_content}"
          end

          puts "Altered webpack development.js"
        else
          puts "development.js already altered"
        end

        unless test_existing_content.include? new_content
          gsub_file(test_dest_file, replace_line) do |match|
            "#{new_content}"
          end

          puts "Altered webpack development.js"
        else
          puts "development.js already altered"
        end
      end

      def extend_babel_to_use_stage_1
        dest_file = ".babelrc"
        existing_content = File.read(dest_file)
        new_content = '"stage-1"'

        unless existing_content.include? new_content
          gsub_file(dest_file, '"react"') do |match|
            "#{match},\n    #{new_content}"
          end

          puts "Babel extended to use stage-1"
        else
          puts "Babel already using stage-1"
        end
      end

      def extend_package_json
        dest_file = "package.json"
        existing_content = File.read(dest_file)
        new_content_1 = '"slickr": "git+https://github.com/primate-inc/slickr#master"'
        new_content_2 = '"babel-preset-stage-1": "^6.24.1"'

        unless existing_content.include? new_content_1
          gsub_file(dest_file, '"dependencies": {') do |match|
            "#{match}\n    #{new_content_1},"
          end

          puts "Package.json extended to Slickr"
        else
          puts "Package.json already using Slickr"
        end

        unless existing_content.include? new_content_2
          gsub_file(dest_file, '"devDependencies": {') do |match|
            "#{match}\n    #{new_content_2},"
          end

          puts "Babel extended to use stage-1"
        else
          puts "Babel already using stage-1"
        end
      end

      def extend_admin_user_class
        dest_file = "app/models/admin_user.rb"
        existing_content = File.read(dest_file)
        new_content = "  include Slickr::AdminUser\n  ROLES = [:admin, :editor, :author, :contributor]"

        unless existing_content.include? new_content
          gsub_file(dest_file, "class AdminUser < ApplicationRecord") do |match|
            "#{match}\n#{new_content}"
          end

          puts "AdminUser extended by Slickr class and roles added"
        else
          puts "AdminUser already extended by Slickr"
        end
      end

      def admin_user_ability
        template "ability.rb", "app/models/ability.rb"

        puts "Slickr yml for webpacker"
      end

      def extend_active_admin_initializer
        dest_file = "config/initializers/active_admin.rb"
        existing_content = File.read(dest_file)
        new_content = "  config.authorization_adapter = ActiveAdmin::CanCanAdapter"

        unless existing_content.include? new_content
          gsub_file(dest_file, "# CanCanAdapter or make your own. Please refer to documentation.") do |match|
            "#{match}\n#{new_content}"
          end

          puts "AdminUser authorization with CanCan"
        else
          puts "AdminUser already authorized with CanCan"
        end
      end
    end
  end
end
