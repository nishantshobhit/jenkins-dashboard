class Widget < ActiveRecord::Base
  attr_accessible :dashboard_id, :name, :data_type, :layout, :size, :from, :to

  @@data_types = [:health, :status, :duration, :commits, :developers]
  @@layouts = [:bar, :line, :text]
  @@sizes = [:small, :medium, :large]

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
    @@layoutsizes[self.layout.to_i]
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

end
