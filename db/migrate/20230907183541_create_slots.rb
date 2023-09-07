# frozen_string_literal: true

class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots do |t|
      t.references :doctor, null: false, foreign_key: { to_table: :users }
      t.datetime :time

      t.timestamps

      t.index [:doctor_id, :time], unique: true
    end
  end
end
