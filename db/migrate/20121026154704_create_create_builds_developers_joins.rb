class CreateCreateBuildsDevelopersJoins < ActiveRecord::Migration
  def self.up
    create_table :builds_developers, :id => false do |t|
      t.integer :build_id
      t.integer :developer_id
    end
  end
  def self.down
    drop_table 'builds_developers'
  end
end
