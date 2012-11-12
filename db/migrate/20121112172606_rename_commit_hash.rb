class RenameCommitHash < ActiveRecord::Migration
  def up
    rename_column :commits, :hash, :sha1hash
  end

  def down
    rename_column :developers, :ha1hash, :hash
  end
end
