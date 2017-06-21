class AddColumnToLogins < ActiveRecord::Migration
  def change
    add_column :logins, :deleted_at, :datetime
  end
end
