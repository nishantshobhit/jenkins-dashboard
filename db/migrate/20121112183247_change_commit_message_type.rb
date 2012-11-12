class ChangeCommitMessageType < ActiveRecord::Migration
  def up
    change_column :commits, :message, :varchar
  end

  def down
    change_column :commits, :message, :string
  end
end
