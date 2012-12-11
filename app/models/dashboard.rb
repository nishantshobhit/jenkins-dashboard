class Dashboard < ActiveRecord::Base
  has_many :widgets
  accepts_nested_attributes_for :widgets

  attr_accessible :layout, :locked, :name
  validates_presence_of :name
end
