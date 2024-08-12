# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171124113241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
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

  create_table "slickr_images", force: :cascade do |t|
    t.string "attachment"
    t.jsonb "dimensions"
    t.jsonb "data", default: {"alt_text"=>""}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "published_at"
    t.datetime "publishing_scheduled_for"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.integer "position"
    t.index ["parent_id"], name: "index_slickr_pages_on_parent_id"
    t.index ["slug"], name: "index_slickr_pages_on_slug", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.integer "admin_id"
    t.boolean "content_changed"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "slickr_event_logs", "admin_users"
end
