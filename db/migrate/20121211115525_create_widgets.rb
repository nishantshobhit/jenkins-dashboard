class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :name
      t.string :kind
      t.string :size
      t.integer :dashboard_id
      t.integer :update_interval

      t.timestamps
    end
  end
end
