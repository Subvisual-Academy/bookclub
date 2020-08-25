class RemoveIsbnFromBook < ActiveRecord::Migration[6.0]
  def change
    remove_column :books, :isbn, :string
  end
end
