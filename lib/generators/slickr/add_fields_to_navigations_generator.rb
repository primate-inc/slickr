require 'rails/generators/active_record'

module Slickr
  module Generators
    class AddFieldsToNavigationsGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc '0.20.12 -> 0.21.0 Copying navigations migration'
      argument :name, type: :string, default: 'application'

      def copy_migrations
        migration_template "updates/add_fields_to_navigations.rb", "db/migrate/add_fields_to_navigations.rb"
        puts 'Copied image migrations'
      end

    end
  end
end
