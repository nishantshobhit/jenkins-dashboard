class ChangeCommitMessageToText < ActiveRecord::Migration
  def up
    change_column :commits, :message, :text
  end

  def down
    change_column :commits, :message, :varchar
  end
end
