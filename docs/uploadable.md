# Uploadable

Slickr has been developed so that separate uploaders are no longer required
for each of your models and all models can share from the same media library.

Below is an example of how to add some images to an example Blog model.

## Model

```ruby
class Blog < ApplicationRecord
  include Slickr::Uploadable

  has_one_slickr_upload(:blog_header_image, :header_image)
  has_one_slickr_upload(:blog_sub_image, :sub_image, true)
end
```

In the above example ```blog_header_image``` sets up the relationship to a
polymorphic model ```Slickr::Upload``` that has an ```uploadable_type```
of ```blog_header_image```. Calling ```blog.blog_header_image``` will return
the ```Slickr::Upload``` object whilst ```blog.header_image``` will return
the ```Slickr::MediaUpload``` object that holds the image/file information.
You can also additionally pass true as a final argument which validates that
the polymorphic relationship must exist when saving a blog object.

## Active Admin

```ruby
ActiveAdmin.register Blog do
  permit_params blog_header_image_attributes: [:slickr_media_upload_id],
                blog_sub_image_attributes: [:slickr_media_upload_id]

  show do |blog|
    attributes_table do
      row :header_image do
        if blog.header_image.present?
          image_tag blog.header_image.image_url(:m_limit)
        end
      end
      row :sub_image do
        if blog.sub_image.present?
          image_tag blog.sub_image.image_url(:m_limit)
        end
      end
    end
  end

  form do |f|
    f.inputs do
      render 'admin/form/image_helper',
             f: f,
             field: :blog_header_image,
             label: 'An override label',
             hint: 'Any hint text you need'
      f.input :blog_header_image, as: :text

      render 'admin/form/image_helper', f: f, field: :blog_sub_image
      f.input :blog_sub_image, as: :text
    end
    f.actions
  end
end
```

Within your Active Admin forms you now have access to the Media library which
appears with a modal and allows you to both choose an image and also drag and
drop images to add new ones.

## Responsive Images

Slickr helper for ```<picture>``` tag to enable responsive images that are
generated in ```Slickr::MediaUpload```

### Example

```ruby
= slickr_picture_tag article.image, version: :xl_fill, image: { alt: ''} do
  = slickr_source_tag srcset: article.image.image_url(:m_fill), media: '(min-width: 200px)', sizes: '100vw'
  = slickr_source_tag srcset: article.image.image_url(:l_fill), media: '(min-width: 600px)', sizes: '100vw'
  = slickr_source_tag srcset: article.image.image_url(:s_fill), sizes: '100vw'
```
