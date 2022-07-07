# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_07_035312) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_fl pper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "game_questions", force: :cascade do |t|
    t.bigint "game_id"
    t.string "question_id"
    t.boolean "correctly_answered"
    t.index ["game_id"], name: "index_game_questions_on_game_id"
    t.index ["question_id"], name: "index_game_questions_on_question_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "number_of_questions", default: 10, null: false
    t.integer "category"
    t.string "difficulty", default: "", null: false
    t.string "game_type", default: "", null: false
    t.string "session_token"
    t.string "game_lifecycle", default: "configured", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "error_message"
    t.integer "current_round", default: 1, null: false
    t.uuid "channel", default: -> { "gen_random_uuid()" }, null: false
    t.boolean "multiplayer", default: false, null: false
  end

  create_table "players", force: :cascade do |t|
    t.uuid "channel"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", id: :string, force: :cascade do |t|
    t.text "body", null: false
    t.string "answer_1", null: false
    t.string "answer_2", null: false
    t.string "answer_3"
    t.string "answer_4"
    t.string "correct_answer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "difficulty", default: "easy", null: false
    t.integer "category_id"
  end

  add_foreign_key "game_questions", "games"
  add_foreign_key "game_questions", "questions"
end
