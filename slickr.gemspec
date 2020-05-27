$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "slickr/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  # s.name        = "slickr"
  s.name        = "slickr_cms"
  s.version     = Slickr::VERSION
  s.authors     = ["Primate"]
  s.email       = ["admin@primate.co.uk"]
  s.homepage    = "https://github.com/primate-inc/slickr"
  s.summary     = "CMS built on top of Active Admin"
  s.description = "CMS built on top of Active Admin."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 6.0"

  s.add_development_dependency "pg"

  # Framework for admin interface
  s.add_dependency "activeadmin", ">= 1.2.1"
  # Authorization
  s.add_dependency "cancancan", "~> 2.0.0"
  # User authentication
  s.add_dependency 'devise', '~> 4.3'
  # Images
  s.add_dependency 'shrine', '>= 3'
  s.add_dependency 'fastimage', '~> 2.1'
  s.add_dependency 'image_processing', '>= 1.7'
  s.add_dependency 'image_optim', '~> 0.26'
  s.add_dependency 'image_optim_pack', '~> 0.5'

  # Other gems
  s.add_dependency "acts_as_tree", "~> 2.7.0"
  s.add_dependency "acts_as_list", "~> 0.9.7"
  s.add_dependency "friendly_id", ">= 5.1.0"
  s.add_dependency "aasm", "~> 4.12.2"
  s.add_dependency "paper_trail", ">= 7.0.0"
  s.add_dependency "public_activity"
  s.add_dependency 'discard', '~> 1.2'
  # s.add_dependency "paper_trail-association_tracking"
  s.add_dependency "draftjs_exporter", "~> 0.0.7"
  s.add_dependency "draper", "~> 3.1.0"
  s.add_dependency "verbs", "~> 2.1.4"
  s.add_dependency "activeadmin_settings_cached", "~> 2.2"
  s.add_dependency "sitemap_generator", "~> 6.0.1"
  s.add_dependency "activeadmin_reorderable", "~> 0.1.2"
  s.add_dependency 'redcarpet', '~> 3.4.0'
  s.add_dependency "ancestry", "~> 3.0"
  s.add_dependency "acts-as-taggable-on", '~> 6.0'
end
