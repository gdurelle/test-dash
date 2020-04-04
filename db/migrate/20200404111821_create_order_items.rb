class CreateOrderItems < ActiveRecord::Migration[6.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :quantity
      t.monetize :unit_price
      t.string :product_code
      t.string :product_description

      t.timestamps
    end
  end
end
