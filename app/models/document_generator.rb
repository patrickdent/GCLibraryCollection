class DocumentGenerator
  include Prawn::View
  require "prawn/measurement_extensions"

  def initialize(format)
    @dimensions = {}
    @format = format
    set_format(format)
  end

  def generate_document(info)
    case @format
    when :label
      make_labels(info)
    else
      puts "FAILURE IN generate_document"
    end
  end

  private

  def dimensions
    @dimensions
  end

  def set_format(format)
    case format
    when :label
      set_label_format
    else
      puts "ERROR IN set_format"
    end
  end

  def set_label_format
    @dimensions[:height] = 0.66
    @dimensions[:width] = 1.75

    @dimensions[:top_margin] = 0.55
    @dimensions[:bottom_margin] = 0.47
    @dimensions[:left_margin] = 0.39
    @dimensions[:right_margin] = 0.31
    
    @dimensions[:gutter] = 0.3

    @dimensions[:rows] = 15
    @dimensions[:columns] = 4
  end

  def make_labels(info)
    document = Prawn::Document.new({page_size: "LETTER",
                                    margin: [@dimensions[:top_margin].in, 
                                             @dimensions[:right_margin].in,
                                             @dimensions[:bottom_margin].in,
                                             @dimensions[:left_margin].in]})  

    #to count labels to know when to go to a new line
    @label_count = 0
    #the x,y position for the upper-left corner
    #of the label
    @x = 0
    @y = document.cursor

    info.each do |i|
      new_label(i, @x, @y, document)
      @label_count += 1
      #change 4 to @dimensions[:columns]
      if @label_count % 60 == 0 then
        document.start_new_page
        @y = cursor
        @x = 0
      elsif @label_count % 4 == 0 then 
        @y -= 0.66.in
        @x = 0
      else
        #change to @dim...:width :gutter
        @x += ( 1.75.in + 0.3.in )   
      end
    end      
 
    document.render_file "test.pdf"
  end

  def new_label(info, x, y, document)
    float do
      document.bounding_box([x, y], width: 1.75.in, height: 0.66.in) do
        #use padding instead of a new line here if you can
        document.text_box( "#{info.title}
                            #{info.authors.first.name}
                            #{info.genre.name}
                            #{info.isbn}
                            ", 
                            overflow: :shrink_to_fit )
      end
    end
  end
end