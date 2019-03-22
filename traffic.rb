require 'tk'

class Car

  def initialize()
    @direction = 2 * Math::PI * rand
    @x = 100 * rand
    @y = 100 * rand
    @speed = 10
    @element = nil
  end

  def tick(canvas)
    @x += Math.cos(@direction) * @speed / 10
    @y += Math.sin(@direction) * @speed / 10
    if @x < 0 || @y < 0 || @x > canvas.winfo_width || @y > canvas.winfo_height
      @direction = 2 * Math::PI * rand
      @x = 0 if @x < 0
      @y = 0 if @y < 0
      @x = canvas.winfo_width if @x > canvas.winfo_width
      @y = canvas.winfo_height if @y > canvas.winfo_height
    end
  end

  def render(canvas)
    canvas.delete(@element) if @element
    @element = TkcLine.new(canvas, @x, @y, @x + Math.cos(@direction) * @speed / 10 , @y + Math.sin(@direction) * @speed / 10, :arrow => 'last', :width => 1, :fill => :yellow)
  end

end

root = TkRoot.new
root.deiconify
@canvas = TkCanvas.new(root, :bg => 'red', :highlightthickness => 0)
@canvas.pack(:fill => 'both', :expand => 1)

@cars = (1..5).map {Car.new}

def render
  @cars.each do |c|
    c.tick(@canvas)
    c.render(@canvas)
  end
  Tk.after(25, proc { render } )
end
Tk.after(0, proc { render } )

Tk.mainloop
