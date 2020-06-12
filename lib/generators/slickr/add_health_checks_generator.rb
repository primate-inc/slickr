require 'rails/generators/active_record'

module Slickr
  module Generators
    class AddHealthChecksGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc 'Creating health checks'
      argument :name, type: :string, default: 'application'

      def copy_migration
        puts 'Copying migration'
        migration_template 'migrations/create_slickr_health_checks.rb', 'migrations/create_slickr_health_checks.rb'
      end
    end
  end
end
