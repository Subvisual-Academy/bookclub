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

ActiveRecord::Schema.define(version: 2020_08_28_201435) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "book_presentations", force: :cascade do |t|
    t.bigint "gathering_id", null: false
    t.bigint "user_id", null: false
    t.bigint "book_id", null: false
    t.boolean "special", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_book_presentations_on_book_id"
    t.index ["gathering_id"], name: "index_book_presentations_on_gathering_id"
    t.index ["user_id"], name: "index_book_presentations_on_user_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.string "author"
    t.text "synopsis"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "google_id"
    t.index ["google_id"], name: "index_books_on_google_id", unique: true
    t.index ["title"], name: "index_books_on_title", unique: true
  end

  create_table "gatherings", force: :cascade do |t|
    t.date "date", null: false
    t.string "special_presentation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "moderator", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "book_presentations", "books"
  add_foreign_key "book_presentations", "gatherings"
  add_foreign_key "book_presentations", "users"
end
