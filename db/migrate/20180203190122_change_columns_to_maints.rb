class ChangeColumnsToMaints < ActiveRecord::Migration
  def change
    rename_column :maints, :data, :maint_type
    add_column :maints, :warranty, :string
    add_column :maints, :data, :text
  end
end
