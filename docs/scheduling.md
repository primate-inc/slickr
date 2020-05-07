# Scheduling

Slickr has scheduling built in with quick buttons to publish/unpublish database
records and also form fields to more accurately set the date time for when the
record should be visible.

Below is an example of how to add scheduling to an example Blog model with an
example of using a scope to only show those records that are not scheduled for
the future.

## Model

```ruby
class Blog < ApplicationRecord
  include Slickr::Schedulable

  scope(:example_scope, lambda do
    published
    ...
  end)
end
```

The schedule is checked and amended if necessary on every page load so there is
no need for the likes of cron jobs to run to remove the schedule once the date
has passed.

If you would like the record to be unpublished on create you can do the
following:

```ruby
class Blog < ApplicationRecord
  include Slickr::Schedulable
  slickr_schedulable on_create: :unpublish

  ...
end
```

## Ability

If you need to control which admin user roles can alter the schedule you can add
something like the following to the ```initialize``` method of
the ```Ability``` class:

```ruby
...
if user.role?('admin')
  can :manage, :all
elsif user.role?('editor')
  can %i[create read], [Blog]
  can %i[update publish], [Blog]
end
...
```

## Active Admin

```ruby
ActiveAdmin.register Blog do
  include Slickr::SharedAdminActions

  includes :schedule

  permit_params do
    params = [
      :title, ...
    ]
    Slickr::PermitAdditionalAdminParams.push_to_params(resource, params)
    params
  end

  filter :published_filter,
         as: :select,
         collection: [['Yes', 'Yes'], ['No', 'No']],
         label: 'Published'

  index do
    selectable_column
    id_column
    ...
    column 'Published' do |blog|
      blog.published?
    end
    ...
    actions
  end

  show do |blog|
    tabs do
      tab 'Content' do
        attributes_table do
          ...
        end
      end
      tab 'Schedule' do
        attributes_table do
          row :published do
            blog.published?
          end
        end
      end
    end
  end

  form do |f|
    tabs do
      tab 'Content' do
        inputs do
          ...
        end
      end
      tab 'Schedule' do
        render 'admin/form/schedule_helper', f: f
      end
    end
    actions
  end
end
```
