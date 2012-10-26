class CreateCreateBuildsCulpritsJoins < ActiveRecord::Migration
  def self.up
    create_table :builds_culprits, :id => false do |t|
      t.integer :build_id
      t.integer :culprit_id
    end
  end
  def self.down
    drop_table 'builds_culprits'
  end
end
