require 'rails/generators/active_record'

module Slickr
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      desc "Running Slickr generators"
      argument :name, type: :string, default: "application"

      def db_migrations
        migration_template "migrations/create_slickr_pages.rb", "db/migrate/create_slickr_pages.rb"
        migration_template "migrations/create_versions.rb", "db/migrate/create_versions.rb"
        migration_template "migrations/add_object_changes_to_versions.rb", "db/migrate/add_object_changes_to_versions.rb"
        migration_template "migrations/change_slickr_pages_page_id_attribute.rb", "db/migrate/change_slickr_pages_page_id_attribute.rb"
        migration_template "migrations/add_meta_data_to_versions.rb", "db/migrate/add_meta_data_to_versions.rb"
        migration_template "migrations/create_slickr_event_logs.rb", "db/migrate/create_slickr_event_logs.rb"
        migration_template "migrations/add_roles_names_and_avatars_to_admin_users.rb", "db/migrate/add_roles_names_and_avatars_to_admin_users.rb"
        migration_template "migrations/add_subheader_to_slickr_pages.rb", "db/migrate/add_subheader_to_slickr_pages.rb"
        migration_template "migrations/add_header_image_to_slickr_pages.rb", "db/migrate/add_header_image_to_slickr_pages.rb"
        migration_template "migrations/create_slickr_settings.rb", "db/migrate/create_slickr_settings.rb"
        migration_template "migrations/create_slickr_navigations.rb", "db/migrate/create_slickr_navigations.rb"
        migration_template "migrations/create_slickr_media_uploads.rb", "db/migrate/create_slickr_media_uploads.rb"
        migration_template "migrations/create_slickr_uploads.rb", "db/migrate/create_slickr_uploads.rb"
        migration_template "migrations/create_slickr_schedules.rb", "db/migrate/create_slickr_schedules.rb"
        migration_template "migrations/add_admin_user_id_to_slickr_pages.rb", "db/migrate/add_admin_user_id_to_slickr_pages.rb"
        migration_template "migrations/create_slickr_meta_tags.rb", "db/migrate/create_slickr_meta_tags.rb"
        migration_template "migrations/add_trackable_to_devise.rb", "db/migrate/add_trackable_to_devise.rb"
        migration_template "migrations/create_slickr_snippets.rb", "db/migrate/create_slickr_snippets.rb"
        migration_template "migrations/create_slickr_snippets_categories.rb", "db/migrate/create_slickr_snippets_categories.rb"

        puts "Database migrations added"
      end

      def shrine_initializer
        template "shrine.rb", "config/initializers/shrine.rb"

        puts "Shrine initializer"
      end

      def slickr_yml
        template "slickr.yml", "config/slickr.yml"

        puts "Slickr yml for webpacker"
      end

      def activeadmin_slickr_pages
        template "slickr_pages.rb", "app/admin/slickr_pages.rb"

        puts "ActiveAdmin Slickr::Page"
      end

      def activeadmin_slickr_snippets
        template "slickr_snippets.rb", "app/admin/slickr_snippets.rb"
        template "slickr_snippets_categories.rb", "app/admin/slickr_snippets_categories.rb"

        puts "ActiveAdmin Slickr::Snippet"
        puts "ActiveAdmin Slickr::SnippetsCategory"
      end

      def activeadmin_media_uploads
        template "media_uploads.rb", "app/admin/media_uploads.rb"

        puts "ActiveAdmin MediaUploads"
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

      def custom_webpack
        template "custom_webpack.js", "config/webpack/custom_webpack.js"

        puts "Custom webpack js for webpacker"
      end

      def alter_webpack_requires
        starting_line = "const environment = require('./environment')"
        dev_dest_file = "config/webpack/development.js"
        pro_dest_file = "config/webpack/production.js"
        test_dest_file = "config/webpack/test.js"
        dev_existing_content = File.read(dev_dest_file)
        pro_existing_content = File.read(pro_dest_file)
        test_existing_content = File.read(test_dest_file)
        new_content = "const merge = require('webpack-merge')\nconst customConfig = require('./custom_webpack')"

        unless dev_existing_content.include? new_content
          gsub_file(dev_dest_file, starting_line) do |match|
            "#{match}\n#{new_content}"
          end

          puts "Altered webpack development.js"
        else
          puts "development.js already altered"
        end

        unless pro_existing_content.include? new_content
          gsub_file(pro_dest_file, starting_line) do |match|
            "#{match}\n#{new_content}"
          end

          puts "Altered webpack production.js"
        else
          puts "production.js already altered"
        end

        unless test_existing_content.include? new_content
          gsub_file(test_dest_file, starting_line) do |match|
            "#{match}\n#{new_content}"
          end

          puts "Altered webpack test.js"
        else
          puts "test.js already altered"
        end
      end

      def alter_webpack_module_exports
        replace_line = "module.exports = environment.toWebpackConfig()"
        dev_dest_file = "config/webpack/development.js"
        pro_dest_file = "config/webpack/production.js"
        test_dest_file = "config/webpack/test.js"
        dev_existing_content = File.read(dev_dest_file)
        pro_existing_content = File.read(pro_dest_file)
        test_existing_content = File.read(test_dest_file)
        new_content = "module.exports = merge(environment.toWebpackConfigForRailsEngine(), customConfig)"

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

      def extend_babel_to_ignore_node_modules
        dest_file = ".babelrc"
        existing_content = File.read(dest_file)
        new_content = '"ignore": "node_modules",'

        unless existing_content.include? new_content
          gsub_file(dest_file, '"presets": [') do |match|
            "#{new_content}\n  #{match}"
          end

          puts "Babel extended to ignore node modules"
        else
          puts "Babel already ignoring node modules"
        end
      end

      def extend_package_json
        dest_file = "package.json"
        existing_content = File.read(dest_file)
        new_content_1 = '"slickr_cms": "git+https://github.com/primate-inc/slickr#master"'
        new_content_2 = '"babel-preset-stage-1": "^6.24.1"'
        new_content_3 = '"ignore-loader": "^0.1.2"'

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

        unless existing_content.include? new_content_3
          gsub_file(dest_file, '"devDependencies": {') do |match|
            "#{match}\n    #{new_content_3},"
          end

          puts "Package.json extended to use ignore-loader"
        else
          puts "Package.json already using ignore-loader"
        end
      end

      def extend_admin_user_class
        dest_file = "app/models/admin_user.rb"
        existing_content = File.read(dest_file)
        new_content = "  include Slickr::SlickrAdminUser\n  ROLES = [:admin, :editor, :author, :contributor]"

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

      def slickr_setting_yml
        template "setting.yml", "config/setting.yml"

        puts "Slickr Setting yml"
      end

      def extend_slickr_page
        template "page.rb", "app/models/slickr/page.rb"

        puts "Slickr Page extended"
      end

      def slickr_media_image_uploader
        template "media_image_uploader.rb", "app/uploaders/slickr/media_image_uploader.rb"

        puts "Slickr::MediaImageUploader added"
      end

      def slickr_media_file_uploader
        template "media_file_uploader.rb", "app/uploaders/slickr/media_file_uploader.rb"

        puts "Slickr::MediaFileUploader added"
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

      def page_edit_megadraft_extensions
        template "javascript_extensions/page_edit/additional_megadraft_actions.js", "app/javascript/slickr_extensions/page_edit/additional_megadraft_actions.js"
        template "javascript_extensions/page_edit/additional_megadraft_block_styles.js", "app/javascript/slickr_extensions/page_edit/additional_megadraft_block_styles.js"
        template "javascript_extensions/page_edit/additional_megadraft_decorators.js", "app/javascript/slickr_extensions/page_edit/additional_megadraft_decorators.js"
        template "javascript_extensions/page_edit/actions/additional_actions.js", "app/javascript/slickr_extensions/page_edit/actions/additional_actions.js"
        template "javascript_extensions/page_edit/components/content/additional_entity_inputs.js", "app/javascript/slickr_extensions/page_edit/components/content/additional_entity_inputs.js"
        template "javascript_extensions/page_edit/components/content/editor_state_change.js", "app/javascript/slickr_extensions/page_edit/components/content/editor_state_change.js"
        template "javascript_extensions/page_edit/containers/additional_prop_types.js", "app/javascript/slickr_extensions/page_edit/containers/additional_prop_types.js"
        template "javascript_extensions/page_edit/decorators/pdf_link_component.jsx", "app/javascript/slickr_extensions/page_edit/decorators/pdf_link_component.jsx"
        template "javascript_extensions/page_edit/entity_inputs/pdf_link_input.jsx", "app/javascript/slickr_extensions/page_edit/entity_inputs/pdf_link_input.jsx"
        template "javascript_extensions/page_edit/plugins/plugin_list.js", "app/javascript/slickr_extensions/page_edit/plugins/plugin_list.js"
        template "javascript_extensions/page_edit/reducers/additional_reducers.js", "app/javascript/slickr_extensions/page_edit/reducers/additional_reducers.js"
        template "javascript_extensions/page_edit/reducers/loaded_pdfs.js", "app/javascript/slickr_extensions/page_edit/reducers/loaded_pdfs.js"

        puts "Sample megadraft extensions added"
      end

      def slickr_page_templates
        template "slickr_page_template.html.erb", "app/views/slickr_page_templates/home.html.erb"
        template "slickr_page_template.html.erb", "app/views/slickr_page_templates/contact.html.erb"
        template "slickr_page_template.html.erb", "app/views/slickr_page_templates/landing.html.erb"
        template "slickr_page_template.html.erb", "app/views/slickr_page_templates/standard.html.erb"

        puts "Sample page templates added"
      end
    end
  end
end
