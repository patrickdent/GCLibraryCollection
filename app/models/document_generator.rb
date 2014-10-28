class DocumentGenerator
  include Prawn::View

  def initialize(format)
    @dimentions = {}
    set_format(format)
  end

  def dimentions
    @dimentions
  end

  private

  def set_format(format)
    case format
    when :label
      set_label_format
    else
      return
    end
  end

  def set_label_format
    @dimentions[:height] = 0.66
    @dimentions[:width] = 1.75

    @dimentions[:top_margin] = 0.55
    @dimentions[:bottom_margin] = 0.47
    @dimentions[:left_margin] = 0.39
    @dimentions[:right_margin] = 0.31
    @dimentions[:padding] = 0.3

    @dimentions[:rows] = 15
    @dimentions[:columns] = 4
  end
end