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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110823115005) do

  create_table "card_timings", :force => true do |t|
    t.integer  "seconds"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", :force => true do |t|
    t.text     "front"
    t.text     "back"
    t.integer  "deck_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pronunciation"
    t.integer  "chapter"
    t.string   "audio_file_name"
  end

  create_table "decks", :force => true do |t|
    t.string   "name",                    :limit => 40
    t.text     "description"
    t.string   "lang",                    :limit => 3
    t.string   "country",                 :limit => 3
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "shared",                                :default => false
    t.string   "pronunciation_side"
    t.boolean  "supports_written_answer"
    t.integer  "review_types"
  end

  create_table "idiom_translations", :force => true do |t|
    t.integer  "idiom_id"
    t.integer  "translation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "idioms", :force => true do |t|
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "related_translations", :force => true do |t|
    t.integer  "translation1_id"
    t.integer  "translation2_id"
    t.boolean  "share_written_form"
    t.boolean  "share_audible_form"
    t.boolean  "share_meaning"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "set_names", :force => true do |t|
    t.integer  "sets_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "set_terms", :force => true do |t|
    t.integer  "set_id"
    t.integer  "term_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter"
    t.integer  "position"
  end

  create_table "sets", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "translations", :force => true do |t|
    t.text     "form"
    t.text     "pronunciation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id"
    t.string   "audio_file_name"
  end

  create_table "user_card_reviews", :force => true do |t|
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "due"
    t.datetime "review_start"
    t.datetime "reveal"
    t.datetime "result_recorded"
    t.string   "result_success"
    t.integer  "interval"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "review_type"
    t.boolean  "gen_from_migrate", :default => false
  end

  create_table "user_card_schedules", :force => true do |t|
    t.integer  "user_id"
    t.integer  "card_id"
    t.datetime "due"
    t.integer  "interval"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_deck_chapters", :force => true do |t|
    t.integer  "user_id"
    t.integer  "deck_id"
    t.integer  "chapter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_idiom_due_items", :force => true do |t|
    t.integer  "user_idiom_schedule_id"
    t.integer  "review_type"
    t.integer  "interval"
    t.datetime "due"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_idiom_reviews", :force => true do |t|
    t.integer  "user_id"
    t.integer  "idiom_id"
    t.integer  "review_type"
    t.datetime "due"
    t.datetime "review_start"
    t.datetime "reveal"
    t.datetime "result_recorded"
    t.integer  "interval"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id"
    t.boolean  "success"
  end

  create_table "user_idiom_schedules", :force => true do |t|
    t.integer  "user_id"
    t.integer  "idiom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id"
  end

  create_table "user_languages", :force => true do |t|
    t.integer  "user_id"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "set_id"
    t.integer  "chapter"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "native_language_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
