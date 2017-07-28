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

ActiveRecord::Schema.define(version: 20170719054923) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.integer  "doc_id"
    t.text     "title"
    t.text     "content"
    t.text     "html_content"
    t.text     "symbol_number"
    t.datetime "public_day"
    t.datetime "day_report"
    t.text     "article_type"
    t.text     "source"
    t.text     "scope"
    t.datetime "effect_day"
    t.text     "effect_status"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "news", force: :cascade do |t|
    t.text     "doc_id"
    t.text     "title"
    t.text     "url"
    t.text     "description"
    t.text     "content"
    t.text     "public_date"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
