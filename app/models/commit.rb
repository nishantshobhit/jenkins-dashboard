class Commit < ActiveRecord::Base
  attr_accessible :build_id, :date, :deletions, :developer_id, :files_changed, :hash, :insertions, :message

  belongs_to :developer, :build

end
