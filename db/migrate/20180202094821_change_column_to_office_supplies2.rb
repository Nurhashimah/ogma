class ChangeColumnToOfficeSupplies2 < ActiveRecord::Migration
  def change
    add_column :stationery_adds, :supplier_id, :integer
    remove_column :stationery_adds, :document, :string
  end
end
