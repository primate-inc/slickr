require 'rails/generators/active_record'

module Slickr
  module Generators
    class AddPaperTrailGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "Adding papertrail"
      argument :name, type: :string, default: "application"

      def install_papetrail
        puts "Installing Papertrail"
        generate "paper_trail:install --with-changes"
        # generate "paper_trail_association_tracking:install"
        migration_template "migrations/add_meta_data_to_versions.rb", "db/migrate/add_meta_data_to_versions.rb"
        puts "Installed Papertrail"
      end
    end
  end
end
