# Meta Tags

You can quickly add the ability to include meta tags to your models in Slickr.

Below is an example of how to add meta tags to an example Blog model and how
to permit the params in Active Admin.

## Model

```ruby
class Blog < ApplicationRecord
  include Slickr::Metatagable

  ...
end
```

You can set the fields to be as defaults for title and description
by adding defaults to your model by telling what attribute you want
to use.

```ruby
  slickr_metatagable(
    defaults: true,
    title: :blog_title,
    description: :blog_description
  )
```
Now when you update the resource, it will save empty fields as the
defaults, or update them only if they are the same. This way you can
you create overrides when necessary.

## Controller

```ruby
class BlogsController < ApplicationController
  ...

  def show
    @blog = Blog.find(params[:id])
    insert_slickr_meta_tags(@blog)
  end

  ...
end
```

## Active Admin

```ruby
ActiveAdmin.register Blog do
  permit_params do
    params = [
      :title, ...
    ]
    Slickr::PermitAdditionalAdminParams.push_to_params(Blog, params)
    params
  end

  ...

  form do |f|
    tabs do
      tab 'Content' do
        inputs do
          ...
        end
      end
      tab 'SEO' do
        render 'admin/form/meta_tag_seo_helper', f: f
      end
      tab 'Social Media' do
        render 'admin/form/meta_tag_social_helper', f: f
      end
    end
    actions
  end

  ...

  controller do
    include Slickr::SharedAdminController

    ...
  end

  ...
end
```

The ```Slickr::SharedAdminController``` module will override
the ```find_resource``` method in ActiveAdmin like so:

```ruby
def find_resource
  return if params[:id].nil?
  scoped_collection.find(params[:id])
end
```

Feel free to roll your own override but be sure to add the first line
in your own method otherwise the ```push_to_params``` method will cause
an exception.
