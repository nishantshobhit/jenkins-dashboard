class AddBuildSuccess < ActiveRecord::Migration
  def up
    add_column :builds, :success, :boolean
  end

  def down
    remove_column :builds, :success
  end
  
end
