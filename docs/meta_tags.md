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
    Slickr::PermitAdditionalAdminParams.push_to_params(resource, params)
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
end
```
