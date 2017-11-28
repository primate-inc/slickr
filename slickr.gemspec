$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "slickr/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "slickr"
  s.version     = Slickr::VERSION
  s.authors     = ["Primate"]
  s.email       = ["admin@primate.co.uk"]
  s.homepage    = ""
  s.summary     = "CMS built on top of Active Admin"
  s.description = "CMS built on top of Active Admin."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "pg"

  # Manage javascript modules
  s.add_dependency "webpacker", "~> 3.0"
  # Framework for admin interface
  s.add_dependency "activeadmin", "2.0.0.alpha"
  # Authorization
  s.add_dependency "cancancan", "~> 2.0.0"
  # User authentication
  s.add_dependency 'devise', '~> 4.3.0'

  # Other gems
  s.add_dependency "acts_as_tree", "~> 2.7.0"
  s.add_dependency "acts_as_list", "~> 0.9.7"
  s.add_dependency "friendly_id", "~> 5.1.0"
  s.add_dependency "aasm", "~> 4.12.2"
  s.add_dependency "paper_trail", "~> 7.0.0"
  s.add_dependency "draftjs_exporter", "~> 0.0.7"
  s.add_dependency "draper", "~> 3.0.0"
  s.add_dependency "verbs", "~> 2.1.4"
end
