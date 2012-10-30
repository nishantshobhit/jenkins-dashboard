class CreateTestReports < ActiveRecord::Migration
  def change
    create_table :test_reports do |t|

      t.timestamps
    end
  end
end
