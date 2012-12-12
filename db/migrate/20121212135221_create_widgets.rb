class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :name
      t.integer :job_id
      t.integer :dashboard_id
      t.integer :data_type
      t.integer :layout
      t.integer :size
      t.datetime :from
      t.datetime :to
      t.timestamps
    end
  end
end
