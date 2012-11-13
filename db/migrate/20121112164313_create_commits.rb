class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :message
      t.string :hash
      t.integer :insertions
      t.integer :deletions
      t.integer :files_changed
      t.integer :developer_id
      t.integer :build_id
      t.datetime :date
      t.integer :spelling_mistakes

      t.timestamps
    end
  end
end
