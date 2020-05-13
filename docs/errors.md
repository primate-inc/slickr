# Error Pages
Slickr sets up dynamic error pages for you.

## Setup
1. Remove the standard 404 page under ```app/public/404.html```.
2. Slickr has a basic page that will then be used but you can easily create your 
own by placing a file at ```app/views/errors/404_error.html.erb```
3. Update ```config/application.rb``` with:
```ruby
config.exceptions_app = self.routes
```
4. To see it in action in your development environment, 
update ```config/environments/development.rb``` with:
```ruby
config.consider_all_requests_local = false
```

The same format can also be followed for 500 error pages although we recommend
you keep the 500.html static page already in your public directory and just
replace the styling to suit your site.
