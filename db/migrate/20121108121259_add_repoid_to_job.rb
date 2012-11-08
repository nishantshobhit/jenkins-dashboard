class AddRepoidToJob < ActiveRecord::Migration
  def up
    add_column :jobs, :repo_id, :integer
  end

  def down
    remove_column :jobs, :repo_id
  end
end
