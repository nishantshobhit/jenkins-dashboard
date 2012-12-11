class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.string :name
      t.string :layout
      t.boolean :locked, :default => false

      t.timestamps
    end
  end
end
