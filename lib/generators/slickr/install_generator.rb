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
          gsub_file(dest_file, /(#{Regexp.escape(insert_after_line)})/mi) do |match|
            "#{match}\n#{new_content}"
          end

          puts "Extended webpacker environment to get packs from Slickr engine"
        else
          puts "Webpacker environment already extended"
        end
      end
    end
  end
end
