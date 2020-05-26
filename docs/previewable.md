# Previewable

You can quickly add the ability to preview individual model pages in Slickr.

Below is an example of how to add preview to Blog model and how
to configure it further.

## Model

```ruby
class Blog < ApplicationRecord
  include include Slickr::Previewable
  slickr_previewable
  ...
end
```

By default preview will use `application` layout and default show template for the model. Both could be overriden and you can also pass in some additional local variables.

```ruby
  slickr_previewable(
    template: lambda { |blog| "slickr_page_templates/#{blog.template}"},
    layout: false,
    locals: lambda { |blog| {
      content: draftjs_to_html(blog, :content)
    } }
  )
```

You can also temporarly remove the preview by setting:

```ruby
  sklickr_previewable(
    preview_enabled: false
  )
```
