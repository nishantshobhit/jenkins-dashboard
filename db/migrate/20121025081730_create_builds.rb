class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.integer :job_id
      t.integer :duration
      t.string :name
      t.integer :number
      t.string :developer
      t.timestamps
    end
  end
end
