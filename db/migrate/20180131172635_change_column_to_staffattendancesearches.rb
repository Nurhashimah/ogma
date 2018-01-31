class ChangeColumnToStaffattendancesearches < ActiveRecord::Migration
  def change
    remove_column :staffattendancesearches, :logged_at, :time
    add_column :staffattendancesearches, :logged_at, :datetime
  end
end
