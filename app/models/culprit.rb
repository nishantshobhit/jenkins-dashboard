class Culprit < ActiveRecord::Base
  attr_accessible :count, :name
  
  class << self
    def update(build)
      unless build.success || build.culprit.nil?
        @query = Culprit.find(:all, :conditions => {:name => build.culprit})
        if @query.length == 0
          @culprit = Culprit.new(:name => build.culprit, :count => 1)
          if @culprit.name
            @culprit.save
          end
        else
          @culprit = @query.first
          count = @culprit.count + 1
          @culprit.update_attributes(:count => count)
        end
      end
    end
  end
  
end
