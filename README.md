# Slickr
Short description and motivation.

[Sitemap configuration](docs/sitemap.md)

## Usage
How to use my plugin.

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

Or install them yourself as:
```bash
gem install active_admin_slickr
gem install slickr
```

## Migrations

After installing the gem run:

```bash
rake db:migrate
```

## CMS

If you don't already have webpacker installed run:

Add this line to your application's Gemfile:

```ruby
gem 'webpacker', '~> 3.0.2'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install webpacker
```

Then install webpacker:
```bash
bundle exec rails Webpacker:install
```

Finally, to use Webpacker with React:
```bash
bundle exec rails webpacker:install:react
```

## Generators

```bash
rails g slickr:install
```

then

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
Ability model

## Admin User

The AdminUser model is already setup through this gem so you can remove your own
version. If however you need to extend it you can still create the ```admin_users.rb```
file within the ```admin``` folder but set it up like so:

```ruby
ActiveAdmin.register AdminUser, as: "Users" do
end
```

## Model Ordering

Slickr uses acts_as_list for ordering. In order to use it in you app you must first
add a ```position``` calumn to the require table:

```ruby
rails g migration AddPositionToAdminUser position:integer
rake db:migrate
```

Then add acts_as_list to your model (and also a default scope if you need it):

```ruby
class AdminUser < ActiveRecord::Base
  acts_as_list
  default_scope { order(position: :asc) }
end
```

In your Active Admin model you then need to add the following:

```ruby
ActiveAdmin.register AdminUser do
  config.sort_order = 'position_asc'
  config.paginate   = false
  reorderable

  ...

  index as: :reorderable_table do
    ...
  end

  ...
end
```

That's it, you now have reorderable tables.

## Extending Megadraft

In text editing mode, Megadraft has a range of options such as bold, italic,
bullet list, etc.  With this editor there is also the ability to add icons to
the toolbar that can display info from your models.

When you run the generator, you will see that a new folder has been added to
the ``` app/javascript ``` folder called ``` slickr_extensions ```. Additionally,
a new model is added under ``` app/models/slickr/page.rb ```.

In ``` app/models/slickr/page.rb ``` you can add to ``` additional_page_edit_paths ```
to include new methods to get info from a model. There is currently an example
method ``` admin_user_index_path ``` which requests the admin index path and has
params of ``` type: 'megadraft_admins') ```.

When the icon is clicked in the Megadraft toolbar, this path will be requested
which requires the controller action to be added to Active Admin AdminUser. For
example add:

```ruby
controller do
  def index
    if params[:type] == 'megadraft_admins'
      @admins = AdminUser.all
      index! do |format|
        format.html { render :json => @admins.to_json }
      end
    else
      index!
    end
  end
end
```

making sure the params match.

### Extending Redux store

In ``` slickr_extensions/page_edit/containers/additional_prop_types.js ``` the
propTypes are extended with our default but you can add to this as needed.

Next we need to handle state change which is done through ``` slickr_extensions/page_edit/reducers/additional_reducers.js ```. Again this is
based on our admins example and simply references a function that responds
to ``` LOAD_ADMINS ``` to get the payload from the admin controller we added above.

The action to trigger this state change is at ``` slickr_extensions/page_edit/actions/additional_actions.js ```.

### Custom Entities

See [Megadraft custom entities](https://github.com/globocom/megadraft/blob/master/docs/custom_entities.md)
for more info.

Megadraft ships with a default entity "LINK" and an according action in the toolbar that allows a user to type in an url. We are adding to it with "ADMIN_LINK" with an action that allows a user to select
an admin email. We extend the entity inputs from ``` slickr_extensions/page_edit/components/content/additional_entity_inputs.js ``` and
agin you can add more as needed.

In order to render the custom entities, we need to define decorators as seen
in ``` slickr_extensions/page_edit/actions/additional_actions.js ```. Upon
highlighting text in the Megadraft editor and then clicking the admin
icon in the Megadraft toolbar, componentWillMount() is fired which in
this case is used to signify a state change in Megadraft and passes ```editorState```
as "load_admins" which is handled in ``` slickr_extensions/page_edit/components/content/editor_state_change.js ```.

The action we setup above to load the admins is now fired and the render method
of entity input is called. This renders a drop down menu on the screen and an
array of admins with a value as a fake link and label of their email populates the drop down.

The value of ``` this.props.url ``` in

```javascript
<Select
  name="form-field-name"
  value={this.props.url}
  options={admins}
  onChange={this.onAdminChange}
/>
```

at this point is undefined but when an admin email is clicked, the rendering in
the editor is handled by ``` slickr_extensions/page_edit/decorators/admin_link_component.jsx ```.
The text you highlighted earlier is now wrapped with a link with an href of
the link you declared in the value of the drop down. The value of ``` this.props.url ```
is now the href value.

## Megadraft to HTML

The content generated by Megadraft needs to be converted to HTML to be displayed
in preview mode or in the front end. If you have added any custom entities you will
need to add to "DRAFTJS_CONFIG" in ``` app/models/slickr/page.rb ``` by adding

``` ruby
'ADMIN_LINK' => DraftjsExporter::Entities::Link.new(className: 'admin__link')
```

for our example in "entity_decorators".

### Page Layouts

For each page you create, you will select a page layout. We have included some
defaults in ``` app/models/slickr/page.rb ``` in the "LAYOUTS" constant but you
can remove or add as many as you like.

For each layout listed in "LAYOUTS" you will need a corresponding file
at ``` app/views/slickr_page_templates ``` with the same name like ``` contact.html.erb```
or ``` contact.slim ```.

The instance variable is accessed as ``` slickr_page``` and the megadraft content
as ``` raw content ```. So as a simple example the page could look as follows:

``` html
<h1><%= page["title"] %></h1>
<p><%= page["page_intro"] %></p>
<%= raw content %>
```

## Megadraft Text Area

Slickr enables the Megadraft editor to be used in text area inputs which normal
Active Admin resources. Below is an example for how to have a mix of normal
text area fields and megadraft text areas:

```ruby
form do |f|
  f.inputs do
    f.input :title
    f.input :body_normal,
            as: :text
    render 'admin/form/text_area_helper', f: f, field: :body_megadraft
    f.input :body_megadraft,
            as: :text
  end
  f.actions
end
```

### View Helper

In order to use the DraftJS output from Megadraft there is a helper available to
use in your views:

```html
<%= draftjs_to_html(@slickr_page, :body_megadraft) %>
```

replacing the instance variable with that generated in your controller and the
second argument with whatever field has the DraftJS content.


## Developing

During development you can use a local copy of the engine in your app and there
are 2 options for doing this. One thing you'll have to do first is you change the
slickr.yml file in the config folder. Comment out:

```bash
slickr: dist
```

and uncomment

```bash
slickr: package/slickr/packs
```

### Option 1

In the main app, package.json file, replace:

```
"slickr": "git+https://github.com/primate-inc/slickr#master"
```

with a local copy like

```
"slickr": "file:/Users/primate/Documents/Projects/slickr"
```

and use the local copy of the engine to load into the main apps node_modules.
This works well if you need to make changes to the codebase that does not
involve the webpacker code.

### Option 2

To live reload your changes on the local engine rather than loading a compiled
version into the main app you can run the following from the engine:

```bash
yarn install
```

to install any missing packages. Then

```bash
yarn link
```

Now in your main app type

```bash
yarn link slickr
```

The local engine now takes precedence over the version in the main app node_modules
folder and when you run the dev server in the main app with

```bash
./bin/webpack-dev-server
```

any changes you make to your engine react code will be live reloaded.

When you're done you can type

```bash
yarn unlink slickr
```

from the main app but note that you'll have to ``` yarn install ``` again as the
slickr node module will be removed.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
