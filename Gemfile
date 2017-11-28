source 'https://rubygems.org'

# Declare your gem's dependencies in slickr.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]
gem 'activeadmin', github: 'activeadmin'

group :development, :test do
  gem 'pry'
  gem 'active_admin_slickr', :git => 'https://github.com/primate-inc/active_admin_slickr.git', :branch => 'master'
  # gem 'active_admin_slickr', :path => '/Users/primate/Documents/gems/active_admin_slickr'
  gem 'webpacker', '~> 3.0.2'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end
