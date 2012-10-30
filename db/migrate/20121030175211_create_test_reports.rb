class CreateTestReports < ActiveRecord::Migration
  def change
    create_table :test_reports do |t|
      t.integer :duration
      t.integer :failed
      t.integer :passed
      t.integer :skipped
      t.integer :build_id
      t.timestamps
    end
  end
end
