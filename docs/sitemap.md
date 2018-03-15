# Sitemap

## Installation

To install sitemap - in your main project folder run

```bash
bundle exec rake sitemap:install
```

The above command generates `config/sitemap.rb` file.

## Sitemap configuration

Edit the file according to agreed spec using the [gem documentation](https://github.com/kjvarga/sitemap_generator#rails).

Test the configuration with command:
```bash
bundle exec rake sitemap:create
```

## Deploy with capistrano


