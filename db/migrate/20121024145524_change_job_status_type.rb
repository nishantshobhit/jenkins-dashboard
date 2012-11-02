class ChangeJobStatusType < ActiveRecord::Migration
  def up
    change_column :jobs, :status, :integer
  end

  def down
    change_column :jobs, :status, :string
  end
end
