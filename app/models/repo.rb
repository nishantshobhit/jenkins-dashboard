class Repo < ActiveRecord::Base
  attr_accessible :branch, :url

  has_many :jobs
end
