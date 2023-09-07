# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :user_type
      t.string :name
      t.string :token

      t.timestamps

      t.index :token, unique: true
    end
  end
end
