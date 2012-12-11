class Widget < ActiveRecord::Base
  belongs_to :dashboard
  attr_accessible :dashboard_id, :kind, :name, :size, :update_interval
end
