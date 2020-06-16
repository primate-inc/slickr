# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_16_151728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "first_name"
    t.string "last_name"
    t.string "avatar"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "slickr_event_logs", force: :cascade do |t|
    t.string "action"
    t.string "eventable_type"
    t.bigint "eventable_id"
    t.bigint "admin_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_slickr_event_logs_on_admin_user_id"
    t.index ["eventable_type", "eventable_id"], name: "index_slickr_event_logs_on_eventable_type_and_eventable_id"
  end

  create_table "slickr_health_checks", force: :cascade do |t|
    t.bigint "healthy_id"
    t.string "healthy_type"
    t.string "check_type"
    t.text "check_result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slickr_media_uploads", force: :cascade do |t|
    t.jsonb "image_data", default: {}, null: false
    t.jsonb "file_data", default: {}, null: false
    t.jsonb "additional_info", default: {"alt_text"=>""}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["additional_info"], name: "index_slickr_media_uploads_on_additional_info", using: :gin
    t.index ["file_data"], name: "index_slickr_media_uploads_on_file_data", using: :gin
    t.index ["image_data"], name: "index_slickr_media_uploads_on_image_data", using: :gin
  end

  create_table "slickr_meta_tags", force: :cascade do |t|
    t.string "title_tag"
    t.text "meta_description"
    t.text "og_title"
    t.text "og_description"
    t.text "twitter_title"
    t.text "twitter_description"
    t.integer "metatagable_id"
    t.string "metatagable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slickr_navigations", force: :cascade do |t|
    t.string "ancestry"
    t.bigint "slickr_page_id"
    t.integer "position"
    t.string "root_type"
    t.string "child_type"
    t.string "title"
    t.text "text"
    t.string "link"
    t.string "link_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_slickr_navigations_on_ancestry"
    t.index ["slickr_page_id"], name: "index_slickr_navigations_on_slickr_page_id"
  end

  create_table "slickr_pages", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "aasm_state"
    t.json "content", default: "[]"
    t.string "type"
    t.integer "slickr_page_id"
    t.integer "active_draft_id"
    t.integer "published_draft_id"
    t.text "page_header"
    t.text "page_intro"
    t.string "layout"
    t.string "meta_title"
    t.text "meta_description"
    t.text "og_title"
    t.text "og_title_2"
    t.text "og_description"
    t.text "og_description_2"
    t.text "og_image"
    t.text "og_image_2"
    t.text "page_subheader"
    t.string "page_header_image"
    t.datetime "published_at"
    t.date "publish_schedule_date"
    t.datetime "publish_schedule_time"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "admin_user_id"
    t.index ["admin_user_id"], name: "index_slickr_pages_on_admin_user_id"
    t.index ["discarded_at"], name: "index_slickr_pages_on_discarded_at"
    t.index ["slug"], name: "index_slickr_pages_on_slug", unique: true
  end

  create_table "slickr_schedules", force: :cascade do |t|
    t.date "publish_schedule_date"
    t.datetime "publish_schedule_time"
    t.integer "schedulable_id"
    t.string "schedulable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slickr_settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_slickr_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "slickr_snippets", force: :cascade do |t|
    t.integer "position"
    t.string "kind"
    t.string "title"
    t.string "header"
    t.string "subheader"
    t.boolean "published", default: false, null: false
    t.text "content"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "slickr_snippets_category_id"
    t.index ["discarded_at"], name: "index_slickr_snippets_on_discarded_at"
  end

  create_table "slickr_snippets_categories", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.string "header"
  end

  create_table "slickr_uploads", force: :cascade do |t|
    t.string "uploadable_type"
    t.bigint "uploadable_id"
    t.bigint "slickr_media_upload_id"
    t.jsonb "additional_info", default: {}, null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["additional_info"], name: "index_slickr_uploads_on_additional_info", using: :gin
    t.index ["slickr_media_upload_id"], name: "index_slickr_uploads_on_slickr_media_upload_id"
    t.index ["uploadable_type", "uploadable_id"], name: "index_slickr_uploads_on_uploadable_type_and_uploadable_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "slickr_event_logs", "admin_users"
end
