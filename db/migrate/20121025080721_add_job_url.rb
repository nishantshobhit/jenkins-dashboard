class AddJobUrl < ActiveRecord::Migration
  def up
    add_column :jobs, :url, :string
  end

  def down
    remove_column :jobs, :url
  end
end
