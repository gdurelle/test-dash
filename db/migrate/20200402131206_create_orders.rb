class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :country
      t.integer :import_id

      t.timestamps
    end
    add_index :orders, :import_id
  end
end
