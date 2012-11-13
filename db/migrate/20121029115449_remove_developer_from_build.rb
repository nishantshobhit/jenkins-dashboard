class RemoveDeveloperFromBuild < ActiveRecord::Migration
  def up
    remove_column :builds, :developer
  end

  def down
    add_column :builds, :developer, :string
  end
end
