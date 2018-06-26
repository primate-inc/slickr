# Helpers

## slickr_nav_menu_image_builder

This helper can be used in views to return the ```Slickr::MediaUpload``` url
for each menu in each navigation tree. For example

```ruby
- top_menu = @slickr_nav_helper[:nav_menus]['Home navigation'][0]
.home-page-intro
  .image-box
    .image style="background-image: url(#{slickr_nav_menu_image_builder(top_menu, 'm_limit')});"
```

## Markdown

Use `format_with_markdown` helper to format markdown. It filters all html tags by default and skips wrapping `<p>` tag.
You need to use `(output).html_safe` in your templates to get right formatting.
