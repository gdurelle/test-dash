class AddImportIdToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :import_id, :integer, null: false
    add_index :customers, :import_id, unique: true
  end
end
