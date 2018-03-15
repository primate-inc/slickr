require "devise"
require "activeadmin"
require "acts_as_tree"
require "acts_as_list"
require "friendly_id"
require "aasm"
require "draftjs_exporter/entities/link"
require 'draftjs_exporter/html'
require "draper"
require "paper_trail"
require "carrierwave"
require "rmagick"
require "cancancan"
require "verbs"
require "activeadmin_settings_cached"

module Slickr
  class Engine < ::Rails::Engine
    initializer 'Slickr', before: :load_config_initializers do
      Rails.application.config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end

    # load the Active Admin engine files into the core application
    initializer :slickr do
      ActiveAdmin.application.load_paths += Dir[File.dirname(__FILE__) + "/admin"]
    end

    # append the engine migrations to the migrations in the core application
    # initializer :append_migrations do |app|
    #   unless app.root.to_s.match(root.to_s)
    #     config.paths["db/migrate"].expanded.each do |expand_path|
    #       app.config.paths["db/migrate"] << expand_path
    #     end
    #   end
    # end
  end
end
