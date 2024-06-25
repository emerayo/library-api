# frozen_string_literal: true

class CreateBookBorrow < ActiveRecord::Migration[7.0]
  def change
    create_table :book_borrows do |t|
      t.references :book, null: false
      t.references :user, null: false
      t.date :start_date, null: false
      t.date :due_date, null: false
      t.boolean :returned, null: false, default: false

      t.timestamps
    end

    add_index :book_borrows, %i[book_id user_id], unique: true
  end
end
