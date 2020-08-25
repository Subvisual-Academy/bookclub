class RemoveBookConstrains < ActiveRecord::Migration[6.0]
  def change
    change_column_null :books, :author, true
    change_column_null :books, :synopsis, true
    change_column_null :books, :image, true
  end
end
