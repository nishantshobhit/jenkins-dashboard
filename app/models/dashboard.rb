class Dashboard < ActiveRecord::Base
  attr_accessible :layout, :locked, :name
end
