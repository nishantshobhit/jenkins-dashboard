class ChangeJobStatusType < ActiveRecord::Migration
  def up
    change_column :jobs, :status, :varchar
  end

  def down
    change_column :jobs, :status, :string
  end
end
