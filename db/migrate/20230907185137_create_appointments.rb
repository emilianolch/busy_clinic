# frozen_string_literal: true

class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.references :patient, null: false, foreign_key: { to_table: :users }
      t.references :slot, null: false, foreign_key: true, index: { unique: true }

      t.timestamps
    end
  end
end
