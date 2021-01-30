## 0.21.0
Copy addtional migrations

```ruby
rails g slickr:add_fields_to_navigations
```

## 0.20.1.1

Moved validators out to new mixin

## 0.20.1.0
Adding HTML validation health checks.

Add gem:

```ruby
gem 'w3c_validators'
```

and add migration for health checks:

```ruby
rails g slickr:add_health_checks
```



## 0.20.0.0
Add aasm_state column to slickr_media_uploads.
Copy new uploaders to your project.


## 0.19.0.0
Image processing additions

Add following gems:

```ruby
gem 'delayed_job_active_record'
```

## 0.18.0.1
Update to image presence validation and view

## 0.18.0.0

Update to javascript packages loading path. Changed which files are copied and using organisation scope @primate-inc.
Files to update:
```ruby
# config/slickr.yml
  include_webpacks:
    '@primate-inc/slickr_cms': 'package/slickr/packs'
```

```ruby
# app/javascript/slickr_extensions/page_edit/entity_inputs/pdf_link_input.jsx

import text_editor_store from '@primate-inc/slickr_cms/package/slickr/packs/slickr_text_area_editor.jsx';
```

```ruby
# config/webpack/environment.js

babelLoader.exclude = /node_modules\/(?!(@primate-inc)\/).*/
babelLoader.include.push(/node_modules\/@primate-inc\/.*/)
```
## 0.17.0.0

Adds taggable images and requires manual installation of acts as taggable gem if upgrading.

In your Gemfile add:

```ruby
  gem 'acts-as-taggable-on', '~> 6.0'
```

Run `rake acts_as_taggable_on_engine:install:migrations` from your command line and run migrations afterwards.
