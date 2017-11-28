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

      def extend_webpacker_environment
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
    end
  end
end
