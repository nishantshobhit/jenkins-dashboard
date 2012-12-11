class Widget < ActiveRecord::Base
  attr_accessible :dashboard_id, :kind, :name, :size, :update_interval
end
