require 'rails/generators/active_record'

module Slickr
  module Generators
    class UpdateGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "Running Slickr update generators"
      argument :name, type: :string, default: "application"

      def add_extended_navigations_fields
        migration_template "migrations/add_extended_navigation_fields_to_slickr_navigations.rb", "db/migrate/add_extended_navigation_fields_to_slickr_navigations.rb"
      end

    end
  end
end
