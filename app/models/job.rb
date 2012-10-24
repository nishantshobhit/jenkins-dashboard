class Job < ActiveRecord::Base
  attr_accessible :name, :status
  
  validates_presence_of :name, :status
  
  @@status_types = [:fixed, :broken, :building, :disabled, :aborted]

  def status_name
    @@status_types[self.status]
  end
  
  def status=(value)
    puts value
    if value.include? "anime"
      value = "building"
    elsif value == "blue"
      value = "fixed"
    elsif value == "red"
      value = "broken"
    elsif value == "grey"
      value = "disabled"
    end
    @status = @@status_types.index(value.to_sym)
    if @status
      write_attribute(:status, @status)
    end
  end
  
end
