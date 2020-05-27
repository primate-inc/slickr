## 0.17.0.0

Adds taggable images and requires manual installation of acts as taggable gem if upgrading.

In your Gemfile add:

```ruby
  gem 'acts-as-taggable-on', '~> 6.0'
```

Run `rake acts_as_taggable_on_engine:install:migrations` from your command line and run migrations afterwards.
