class AddImportIdToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :import_id, :integer, uniq: true
  end
end
