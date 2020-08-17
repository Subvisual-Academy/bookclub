class CreateBookPresentations < ActiveRecord::Migration[6.0]
  def change
    create_table :book_presentations do |t|
      t.belongs_to :gathering, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :book, null: false, foreign_key: true
      t.boolean :special, default: false

      t.timestamps
    end
  end
end
