# Slickr
Short description and motivation.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'slickr'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install slickr
```

## Migrations

After installing the gem, slimply run:

```bash
$ rake db:migrate
```

## CMS

If you don't already have webpacker installed run:

Add this line to your application's Gemfile:

```ruby
gem 'webpacker', '~> 3.0.2'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install webpacker
```

Then install webpacker:
```bash
bundle exec rails Webpacker:install
```

Finally, to use Webpacker with React:
```bash
bundle exec rails webpacker:install:react
```

## Generators

```bash
rails g slickr:install
```

then

```bash
yarn install
```

For now you also have to open up node_modules folder and find the folders for
attr-accept and disposables and delete the .babelrc files

## Webpack local

When developing the engine with another app it's useful to use a local of of the
engine in webpack rather than the github master version.

In the main app, package.json file, replace:

```
"slickr": "git+https://github.com/primate-inc/slickr#master"
```

with

```
"slickr": "file:/Users/primate/Documents/Projects/slickr"
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
