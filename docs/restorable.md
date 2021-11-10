# Restorable

You can quickly add soft delete and restore flow to your models in Slickr.
Resotrable uses [Discard gem](https://github.com/jhawthorn/discard) in the background.

This will create default scope for your undiscarded, or `kept` records. To inspect `discarded` records, you'll first need to [unscope](https://apidock.com/rails/ActiveRecord/Base/unscoped/class) your query.

Below is an example of adding restorable to Blog model.

## Model

```ruby
class Blog < ApplicationRecord
  include Slickr::Restorable
  slickr_restorable
  ...
end

```

## Active Admin adapter

```ruby

ActiveAdmin.register Blog do
  include Slickr::SharedAdminActions
  actions :all, except: %[show]
  ...

  index do
  ...

    actions defaults: false do |record|
      item 'Edit', edit_admin_blog_path(record)
      item 'Delete', discard_admin_blog_path(record)
    end
  end
  ...

  controller do
    include Slickr::SharedAdminController
  end
end

```
