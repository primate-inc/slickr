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
