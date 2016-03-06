# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160306105124) do

  create_table "categories", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.text     "description",        limit: 65535
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "parent_category_id", limit: 4
    t.integer  "shop_id",            limit: 4
  end

  add_index "categories", ["parent_category_id"], name: "index_categories_on_parent_category_id", using: :btree
  add_index "categories", ["shop_id"], name: "index_categories_on_shop_id", using: :btree
  add_index "categories", ["title"], name: "index_categories_on_title", unique: true, using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.string   "name",       limit: 255
    t.string   "phone",      limit: 255
    t.string   "country",    limit: 255
    t.string   "city",       limit: 255
    t.string   "address",    limit: 255
    t.string   "comment",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "order_id",   limit: 4
  end

  add_index "contacts", ["order_id"], name: "index_contacts_on_order_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "discounts", force: :cascade do |t|
    t.decimal  "initial_sum",           precision: 9, scale: 2
    t.decimal  "percent",               precision: 4, scale: 2
    t.integer  "shop_id",     limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "discounts", ["shop_id"], name: "index_discounts_on_shop_id", using: :btree

  create_table "distributions", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body",       limit: 65535
    t.integer  "shop_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "distributions", ["shop_id"], name: "index_distributions_on_shop_id", using: :btree

  create_table "favourites", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "product_id", limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "favourites", ["product_id"], name: "index_favourites_on_product_id", using: :btree
  add_index "favourites", ["user_id", "product_id"], name: "index_favourites_on_user_id_and_product_id", unique: true, using: :btree
  add_index "favourites", ["user_id"], name: "index_favourites_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "file",           limit: 255
    t.integer  "imageable_id",   limit: 4
    t.string   "imageable_type", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "images", ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id", limit: 4
    t.integer  "order_id",   limit: 4
    t.integer  "quantity",   limit: 4, default: 1
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "status",        limit: 255
    t.decimal  "total",                     precision: 8, scale: 2
    t.string   "pay_type",      limit: 255
    t.integer  "user_id",       limit: 4
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "delivery_type", limit: 255
    t.string   "comment",       limit: 255
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "description", limit: 65535
    t.decimal  "price",                     precision: 8, scale: 2
    t.integer  "category_id", limit: 4
    t.boolean  "published"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.integer  "quantity",    limit: 4,                             default: 0
    t.decimal  "weight",                    precision: 6, scale: 3, default: 0.0
    t.integer  "stock_id",    limit: 4
    t.decimal  "rating",                    precision: 4, scale: 2
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id", using: :btree
  add_index "products", ["stock_id"], name: "index_products_on_stock_id", using: :btree
  add_index "products", ["title"], name: "index_products_on_title", unique: true, using: :btree

  create_table "reviews", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body",       limit: 65535
    t.integer  "rating",     limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "product_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "reviews", ["product_id"], name: "index_reviews_on_product_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "shops", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.string   "register_number", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "shops", ["register_number"], name: "index_shops_on_register_number", unique: true, using: :btree
  add_index "shops", ["title"], name: "index_shops_on_title", unique: true, using: :btree

  create_table "stocks", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "percent",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                       limit: 255,   default: "",         null: false
    t.string   "encrypted_password",          limit: 255,   default: "",         null: false
    t.string   "reset_password_token",        limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               limit: 4,     default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",          limit: 255
    t.string   "last_sign_in_ip",             limit: 255
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.string   "reset_password_redirect_url", limit: 255
    t.string   "provider",                    limit: 255
    t.string   "uid",                         limit: 255,   default: "",         null: false
    t.text     "tokens",                      limit: 65535
    t.string   "role",                        limit: 255,   default: "customer"
    t.string   "name",                        limit: 255
    t.string   "sex",                         limit: 255
    t.string   "phone",                       limit: 255
    t.string   "country",                     limit: 255
    t.string   "city",                        limit: 255
    t.string   "address",                     limit: 255
    t.date     "birthday"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", unique: true, using: :btree

  add_foreign_key "categories", "shops"
  add_foreign_key "contacts", "orders"
  add_foreign_key "discounts", "shops"
  add_foreign_key "distributions", "shops"
  add_foreign_key "favourites", "products"
  add_foreign_key "favourites", "users"
  add_foreign_key "products", "stocks"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "users"
end
