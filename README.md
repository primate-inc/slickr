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

## Developing

During development with a local copy of the engine being used with another app
there are 2 options:

### Option 1

In the main app, package.json file, replace:

```
"slickr": "git+https://github.com/primate-inc/slickr#master"
```

with

```
"slickr": "file:/Users/primate/Documents/Projects/slickr"
```

and use the local copy of the engine to load into the main apps node_modules.

### Option 2

To live reload your changes on the local engine rather than loading a compiled
version into the main app you can run the following from the engine:

```bash
yarn install
```

to install any missing packages. Then

```bash
yarn link
```

followed by

```bash
yarn build
```

Now in your main app type

```bash
yarn link slickr
```

The local engine now takes precedence over the version in the main app node_modules
folder and when you run the dev server in the main app with

```bash
./bin/webpack-dev-server
```

any changes you make to your engine react code will be live reloaded.


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
