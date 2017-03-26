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

ActiveRecord::Schema.define(version: 20170304194426) do

  create_table "brands", force: :cascade do |t|
    t.string   "name",       limit: 512,                         null: false
    t.boolean  "featured",               default: false
    t.string   "status",     limit: 16,  default: "unpublished", null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "priority",               default: 1000
    t.index ["status"], name: "index_brands_on_status"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",          limit: 128,                         null: false
    t.string   "one_liner"
    t.string   "permalink",     limit: 128,                         null: false
    t.text     "description"
    t.integer  "parent_id"
    t.integer  "top_parent_id"
    t.string   "status",        limit: 16,  default: "unpublished", null: false
    t.boolean  "featured",                  default: false
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.integer  "priority",                  default: 1000
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["permalink"], name: "index_categories_on_permalink", unique: true
    t.index ["status"], name: "index_categories_on_status"
    t.index ["top_parent_id"], name: "index_categories_on_top_parent_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string   "document"
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["documentable_id", "documentable_type"], name: "index_documents_on_documentable_id_and_documentable_type"
  end

  create_table "enquiries", force: :cascade do |t|
    t.string   "name",       limit: 128,                    null: false
    t.string   "email",      limit: 256,                    null: false
    t.string   "phone",      limit: 24,                     null: false
    t.string   "subject",    limit: 256,                    null: false
    t.text     "message"
    t.string   "status",     limit: 16,  default: "unread", null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "title",        limit: 512,                         null: false
    t.string   "permalink",    limit: 32,                          null: false
    t.string   "venue",        limit: 256,                         null: false
    t.text     "description1"
    t.text     "description2"
    t.text     "description3"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "news",                     default: true
    t.date     "news_date"
    t.boolean  "featured",                 default: false
    t.string   "status",       limit: 16,  default: "unpublished", null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.index ["permalink"], name: "index_events_on_permalink", unique: true
    t.index ["status"], name: "index_events_on_status"
  end

  create_table "images", force: :cascade do |t|
    t.string   "image"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name",            limit: 128,                         null: false
    t.string   "permalink",       limit: 128,                         null: false
    t.string   "one_liner"
    t.text     "description"
    t.integer  "brand_id"
    t.integer  "category_id"
    t.integer  "top_category_id"
    t.string   "status",          limit: 16,  default: "unpublished", null: false
    t.boolean  "featured",                    default: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.integer  "priority",                    default: 1000
    t.string   "sku",             limit: 128
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["permalink"], name: "index_products_on_permalink", unique: true
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["status"], name: "index_products_on_status"
    t.index ["top_category_id"], name: "index_products_on_top_category_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",        limit: 128,                         null: false
    t.string   "designation", limit: 256,                         null: false
    t.string   "description", limit: 256,                         null: false
    t.string   "status",      limit: 16,  default: "unpublished", null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["status"], name: "index_teams_on_status"
  end

  create_table "testimonials", force: :cascade do |t|
    t.string   "name",         limit: 128,                         null: false
    t.string   "designation",  limit: 256,                         null: false
    t.string   "organisation", limit: 256,                         null: false
    t.text     "statement"
    t.string   "status",       limit: 16,  default: "unpublished", null: false
    t.boolean  "featured",                 default: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.index ["status"], name: "index_testimonials_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 256
    t.string   "username",               limit: 32,                       null: false
    t.string   "email",                                                   null: false
    t.string   "phone",                  limit: 24
    t.string   "designation",            limit: 56
    t.boolean  "super_admin",                        default: false
    t.string   "status",                 limit: 16,  default: "inactive", null: false
    t.string   "password_digest",                                         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                    default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "auth_token"
    t.datetime "token_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
