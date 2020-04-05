class AddTotalAmountToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :total_amount, :decimal
  end
end
