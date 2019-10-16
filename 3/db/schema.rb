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

ActiveRecord::Schema.define(version: 2019_10_16_082208) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "product_articles", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "sku"
    t.float "price"
    t.bigint "product_id"
    t.index ["product_id"], name: "index_product_articles_on_product_id"
  end

  create_table "product_photos", force: :cascade do |t|
    t.string "url"
    t.bigint "product_article_id"
    t.index ["product_article_id"], name: "index_product_photos_on_product_article_id"
  end

  create_table "product_sizes", force: :cascade do |t|
    t.string "sku"
    t.boolean "available"
    t.bigint "product_article_id"
    t.bigint "size_id"
    t.index ["product_article_id"], name: "index_product_sizes_on_product_article_id"
    t.index ["size_id"], name: "index_product_sizes_on_size_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "sku"
  end

  create_table "sizes", force: :cascade do |t|
    t.string "name"
  end

  add_foreign_key "product_articles", "products"
  add_foreign_key "product_photos", "product_articles"
  add_foreign_key "product_sizes", "product_articles"
  add_foreign_key "product_sizes", "sizes"
end
