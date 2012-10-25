class CreateCulprits < ActiveRecord::Migration
  def change
    create_table :culprits do |t|
      t.string :name
      t.integer :count

      t.timestamps
    end
  end
end
