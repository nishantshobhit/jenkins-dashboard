class AddUrlToBuild < ActiveRecord::Migration
  def up
    add_column :builds, :url, :string
  end

  def down
    remove_column :builds, :url
  end
  
end
