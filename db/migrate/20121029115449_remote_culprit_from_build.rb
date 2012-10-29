class RemoteCulpritFromBuild < ActiveRecord::Migration
  def up
    remove_column :builds, :culprit
  end

  def down
    add_column :builds, :culprit, :string
  end
end
