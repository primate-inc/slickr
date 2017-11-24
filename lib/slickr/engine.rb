require 'devise'
require 'activeadmin'
require 'acts_as_tree'
require 'acts_as_list'
require 'friendly_id'
require 'aasm'
require 'draftjs_exporter/entities/link'
require 'draper'
require 'paper_trail'

module Slickr
  class Engine < ::Rails::Engine
    initializer :slickr do
      ActiveAdmin.application.load_paths += Dir[File.dirname(__FILE__) + '/admin']
    end
  end
end
