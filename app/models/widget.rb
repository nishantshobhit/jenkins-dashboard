class Widget < ActiveRecord::Base
  attr_accessible :dashboard_id, :name, :data_type, :layout, :size, :from, :to, :job_id
  belongs_to :dashboard
  belongs_to :job

  @@data_types = [:health, :status, :duration, :commits, :developers]
  @@layouts = [:bar, :line, :text]
  @@sizes = [:small, :medium, :large]

  def span_size
    if self.size
      (self.size) + 4
    else
      4
    end
  end

  def data_types
    @@data_types
  end

  def layouts
    @@layouts
  end

  def sizes
    @@sizes
  end

  def data_type_name
    @@data_types[self.data_type.to_i]
  end

  def data_type=(value)
    @data_type = @@data_types.index(value.downcase.to_sym)
    if @data_type
      write_attribute(:data_type, @data_type)
    end
  end

  def layout_name
    @@layouts[self.layout.to_i]
  end

  def layout=(value)
    @layout = @@layouts.index(value.downcase.to_sym)
    if @layout
      write_attribute(:layout, @layout)
    end
  end

  def size_name
    @@sizes[self.size.to_i]
  end

  def size=(value)
    @size = @@sizes.index(value.downcase.to_sym)
    if @size
      write_attribute(:size, @size)
    end
  end

  def to=(value)
    write_attribute(:to, value.to_datetime)
  end

  def from=(value)
    write_attribute(:from, value.to_datetime)
  end

end
