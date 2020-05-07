# Updates

Below is instructions on steps to take in order to upgrade the CMS on your
site. Please follow the steps in order and work from version to version.

## Version 0.14

1. Install updates from Slickr

```bash
rails g slickr:install --skip
```

2. Open ```admin/slickr_pages``` and add params for schedulable and also
add ```admin_user_id``` to the params:

```ruby
permit_params :page_title, ..., :admin_user_id,
              schedule_attributes: [
                :publish_schedule_date, :publish_schedule_time
              ]
```

3. Add admin hidden input to new record and change schedule tab to use
new helper

```ruby
form do |f|
  if object.new_record?
    inputs do
      input :admin_user_id,
            input_html: { value: current_admin_user.id }, as: :hidden
      ...
    end
    actions
  else
    ...
    tabs do
      ...
      tab 'Schedule' do
        render 'admin/form/schedule_helper', f: f
      end
    end
    actions
  end
end
```

4. Before pushing to live site, take a note of which Slickr::Pages are currently
in draft. After pushing updated code to server, open each page in Active Admin
and click 'Unpublish'

5. Change all aasm_state records in Slickr::Page from 'published'
to 'live_version':

```ruby
Slickr::Page.where(aasm_state: 'published').each do |page|
  page.update_attribute(:aasm_state, 'live_version')
end
```

6. See docs for adding scheduling to other models and if you have a scope in
your model called ```published``` be sure to remove it as this is now handled
by ```Slickr::Schedulable```.

## Version 0.15

1. Install updates from Slickr

```bash
rails g slickr:install --skip
```

2. Open ```admin/slickr_pages``` and now remove params for schedulable from
the previous version and permit the params like so:

```ruby
permit_params do
  params = [
    :page_title, ...
  ]
  Slickr::PermitAdditionalAdminParams.push_to_params(resource, params)
  params
end
```

3. Use new helpers for SEO and Social Media tabs:

```ruby
form do |f|
  ...
  tabs do
    ...
    tab 'SEO' do
      render 'admin/form/meta_tag_seo_helper', f: f
    end
    tab 'Social Media' do
      render 'admin/form/meta_tag_social_helper', f: f
    end
    ...
  end
  actions
end
```

4. When pushing live, all meta tags will now need to be created in the
polymorphic model which can be done as follows:

```ruby
Slickr::Page.where(aasm_state: 'live_version').each do |page|
  page.meta_tag = Slickr::MetaTag.new(
    title_tag: page.page_title,
    meta_description: page.meta_description,
    og_title: page.og_title,
    og_description: page.og_description,
    twitter_title: page.twitter_title,
    twitter_description: page.twitter_description
  )
end
```

5. Follow documentation to add meta tags to other models
