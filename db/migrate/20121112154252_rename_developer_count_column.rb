class RenameDeveloperCountColumn < ActiveRecord::Migration
  def up
    rename_column :developers, :count, :broken_build_count
  end

  def down
    rename_column :developers, :broken_build_count, :count
  end
end
