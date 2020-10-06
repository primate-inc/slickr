require 'rails/generators/active_record'

module Slickr
  module Generators
    class CopyPublicFilesGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../../public/files', __dir__)
      desc 'Copying files'
      argument :name, type: :string, default: 'application'

      def copy_image_fallback
        puts 'Copying image fallback'
        template 'fallback.svg', 'public/image_fallback/fallback.svg'
        puts 'Copied image fallback'
      end
    end
  end
end
