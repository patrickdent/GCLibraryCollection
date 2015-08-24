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

ActiveRecord::Schema.define(version: 20150823225223) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_stat_statements"

  create_table "authors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sort_by"
  end

  create_table "book_authors", force: true do |t|
    t.integer  "book_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contribution_id"
    t.boolean  "primary",         default: false
  end

  add_index "book_authors", ["author_id"], name: "index_book_authors_on_author_id", using: :btree
  add_index "book_authors", ["book_id"], name: "index_book_authors_on_book_id", using: :btree

  create_table "book_keywords", force: true do |t|
    t.integer  "book_id"
    t.integer  "keyword_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "book_keywords", ["book_id"], name: "index_book_keywords_on_book_id", using: :btree
  add_index "book_keywords", ["keyword_id"], name: "index_book_keywords_on_keyword_id", using: :btree

  create_table "book_uploads", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
    t.string   "genre"
  end

  create_table "books", force: true do |t|
    t.string   "title"
    t.string   "isbn"
    t.integer  "genre_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "publisher"
    t.string   "publish_date"
    t.string   "publication_place"
    t.string   "language"
    t.integer  "pages"
    t.string   "location"
    t.boolean  "available",         default: true
    t.integer  "count",             default: 1
    t.boolean  "in_storage",        default: false
    t.boolean  "missing",           default: false
    t.boolean  "notable"
    t.boolean  "keep_multiple"
    t.boolean  "inventoried",       default: false
  end

  add_index "books", ["genre_id"], name: "index_books_on_genre_id", using: :btree
  add_index "books", ["isbn"], name: "index_books_on_isbn", using: :btree
  add_index "books", ["location"], name: "index_books_on_location", using: :btree
  add_index "books", ["title"], name: "index_books_on_title", using: :btree

  create_table "contributions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbreviation",     null: false
    t.datetime "last_inventoried"
  end

  add_index "genres", ["name"], name: "index_genres_on_name", using: :btree

  create_table "keywords", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "keywords", ["name"], name: "index_keywords_on_name", using: :btree

  create_table "loans", force: true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.date     "start_date"
    t.date     "due_date"
    t.date     "returned_date"
    t.integer  "renewal_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loans", ["book_id"], name: "index_loans_on_book_id", using: :btree
  add_index "loans", ["user_id"], name: "index_loans_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "user_uploads", force: true do |t|
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "notes"
    t.string   "name"
    t.string   "phone"
    t.string   "preferred_first_name"
    t.text     "address"
    t.string   "identification"
    t.boolean  "do_not_lend"
    t.string   "username"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.boolean  "deactivated",            default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["preferred_first_name"], name: "index_users_on_preferred_first_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
