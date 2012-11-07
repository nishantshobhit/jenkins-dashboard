class AddBuildDateColumn < ActiveRecord::Migration
  def up
    add_column :builds, :date, :datetime
  end

  def down
    remove_column :builds, :date
  end
end
