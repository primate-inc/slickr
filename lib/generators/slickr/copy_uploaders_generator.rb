require 'rails/generators/active_record'

module Slickr
  module Generators
    class CopyUploadersGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../../../app/uploaders', __FILE__)
      desc 'Copying uploaders'
      argument :name, type: :string, default: 'application'

      def copy_image_uploader
        puts 'Copying image uploader'
        migration_template 'media_image_uploader.rb', 'app/uploaders/media_image_uploader.rb'
        puts 'Copied image uploader'
      end

      def copy_file_uploader
        puts 'Copying file uploader'
        migration_template 'media_file_uploader.rb', 'app/uploaders/media_file_uploader.rb'
        puts 'Copied file uploader'
      end
    end
  end
end
