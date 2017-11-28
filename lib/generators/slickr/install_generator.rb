require 'rails/generators/active_record'

module ActiveAdminSlickr
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "No blank slate layout for slickr images on Active Admin"
      argument :name, type: :string, default: "application"

      def no_blank_slate
        template "active_admin_no_blank_slate.rb", "config/initializers/active_admin_no_blank_slate.rb"

        puts "No blank slate for Slickr images"
      end
    end
  end
end
