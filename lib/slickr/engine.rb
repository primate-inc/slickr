require 'devise'
require 'activeadmin'
require 'acts_as_tree'
require 'acts_as_list'
require 'friendly_id'
require 'aasm'
require 'draftjs_exporter/entities/link'
require 'draftjs_exporter/html'
require 'draper'
require 'paper_trail'
require 'fastimage'
require 'image_processing'
require 'shrine'
require 'image_optim'
require 'image_optim_pack'
require 'cancancan'
require 'verbs'
require 'activeadmin_settings_cached'
require 'sitemap_generator'
require 'activeadmin_reorderable'
require 'ancestry'

module Slickr
  class Engine < ::Rails::Engine
    initializer 'Slickr', before: :load_config_initializers do
      Rails.application.config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end

    # load the Active Admin engine files into the core application
    # load them in first to allow app user to override
    initializer :slickr do
      # ActiveAdmin.application.load_paths += Dir[File.dirname(__FILE__) + '/admin']
      ActiveAdmin.application.load_paths
                 .unshift Dir[File.dirname(__FILE__) + '/admin']
    end

    # load the Slickr Settings everytime
    initializer :extend_application_controller do
      ActionController::Base.send :include, Slickr::EngineController
      ActionController::Base.send :before_action, :fetch_slickr_settings
    end
  end
end
