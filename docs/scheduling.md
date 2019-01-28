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

## Active Admin

```ruby
ActiveAdmin.register Blog do
  include Slickr::SharedAdminActions

  includes :schedule

  permit_params ...,
                schedule_attributes: %i[
                  publish_schedule_date publish_schedule_time
                ]

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