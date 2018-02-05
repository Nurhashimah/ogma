class ChangeColumnsToTrainingnotes < ActiveRecord::Migration
  def change
    remove_column :trainingnotes, :data, :string
    add_column :trainingnotes, :data, :text
  end
end
