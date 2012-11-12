class CreateDevelopers < ActiveRecord::Migration
  def change
    create_table :developers do |t|
      t.string :name
      t.integer :count

      t.timestamps
    end
  end
end
