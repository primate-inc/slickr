# Model Ordering

Slickr uses [ActsAsList](https://github.com/swanandp/acts_as_list) for ordering.
In order to use it in you app you must first add a ```position``` column to the
required table like in the example below:

```ruby
rails g migration AddPositionToAdminUser position:integer
rake db:migrate
```

Then add acts_as_list to your model (and also a default scope if you need it):

```ruby
class AdminUser < ActiveRecord::Base
  acts_as_list
  default_scope { order(position: :asc) }
end
```

In your Active Admin model you then need to add the following:

```ruby
ActiveAdmin.register AdminUser do
  config.sort_order = 'position_asc'
  config.paginate   = false
  reorderable

  ...

  index as: :reorderable_table do
    ...
  end

  ...
end
```

That's it, you now have reorderable tables.
