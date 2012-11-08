class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :url
      t.string :branch

      t.timestamps
    end
  end
end
