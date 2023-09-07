# frozen_string_literal: true

class RenameUsersType < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :user_type, :type
  end
end
