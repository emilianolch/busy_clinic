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

ActiveRecord::Schema[7.0].define(version: 2023_09_07_212255) do
  create_table "appointments", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "slot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
    t.index ["slot_id"], name: "index_appointments_on_slot_id", unique: true
  end

  create_table "slots", force: :cascade do |t|
    t.integer "doctor_id", null: false
    t.datetime "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id", "time"], name: "index_slots_on_doctor_id_and_time", unique: true
    t.index ["doctor_id"], name: "index_slots_on_doctor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  add_foreign_key "appointments", "slots"
  add_foreign_key "appointments", "users", column: "patient_id"
  add_foreign_key "slots", "users", column: "doctor_id"
end
