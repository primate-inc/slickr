# Restorable

You can quickly add soft delete and restore flow to your models in Slickr.
Resotrable uses [Discard gem](https://github.com/jhawthorn/discard) in the background.

Below is an example of adding restorable to Blog model.

## Model

```ruby
class Blog < ApplicationRecord
  include Slickr::Restorable
  slickr_restorable
  ...
end
```

