class Dashboard < ActiveRecord::Base
  attr_accessible :layout, :locked, :name
  validates_presence_of :name
end
