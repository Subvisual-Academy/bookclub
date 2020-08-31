class MakeNameAndTitleIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :name, :unique => true
    add_index :books, :title, :unique => true
  end
end
