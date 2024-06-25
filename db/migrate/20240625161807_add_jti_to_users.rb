# frozen_string_literal: true

# rubocop:disable Rails/NotNullColumn
class AddJtiToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :jti, :string, null: false
    add_index :users, :jti, unique: true
  end
end
# rubocop:enable Rails/NotNullColumn
