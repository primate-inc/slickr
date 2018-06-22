# Slickr

Short description and motivation.

## Prerequisites

You must have both [Active Admin](https://github.com/activeadmin/activeadmin)
and [Webpacker](https://github.com/rails/webpacker) with React already installed
and setup.

## Installation
Add these lines to your application's Gemfile:

```ruby
gem 'active_admin_slickr'
gem 'slickr'
```

And then execute:
```bash
bundle
```

Then run the generator:

```bash
rails g slickr:install
```

followed by

```bash
rake db:migrate
```

and finally

```bash
yarn install
```

## Stylesheets

Firstly, please comment out the default Active Admin stylesheets.

```css
// Active Admin's got SASS!
// @import "active_admin/mixins";
// @import "active_admin/base";
```

Then add the following in `active_admin.scss`:

```css
@import 'active_admin_slickr';
@import 'slickr/slickr_styles';
```

## Javascript
- In the `active_admin.js` file, you require:

```javascript
//= require active_admin/base
//= require active_admin_slickr
//= require slickr/slickr_javascript
```

## Roles

You will have some basic default roles added to your AdminUser model which you
can easily add to. Roles are managed by CanCanCan and can be altered in the
Ability model.

To alter the roles, change the values in the ```ROLES``` constant located
at ```app/models/admin_user.rb```

Then you can manage permissions at ```app/models/ability.rb```

Finally, ensure your AdminUser has been assigned one of the roles.

## Admin User

The AdminUser file within the ```app/admin``` path is already setup through this
gem so you can remove your own version. If however you need to extend it you can
still create the ```admin_users.rb``` file within the ```app/admin``` folder
but set it up like so:

```ruby
ActiveAdmin.register AdminUser, as: "Users" do
end
```

## HTTP Basic Auth

If your site is using HTTP Basic Auth and media files are stored at an external
location then please add the following to the relevant ```config/environments```
file with your own user and password details.

```ruby
config.slickr_http_basic_auth_required = true
config.slickr_http_basic_auth_user = 'Joe'
config.slickr_http_basic_auth_password = 'Bloggs'
```

## Image Processing

[Image Processing](docs/image_processing.md)

## Helpers

[Heleprs](docs/helpers.md)

## Error pages

[Error page configuration](docs/errors.md)

## Model Ordering

[Model ordering setup](docs/ordering.md)

## Sitemap

[Sitemap configuration](docs/sitemap.md)

## Megadraft

[Megadraft configuration](docs/megadraft.md)

## Developing

[Developing with slickr_cms](docs/development.md)

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
