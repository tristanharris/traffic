require 'tk'

class Car

  attr_reader :x, :y

  def initialize()
    @direction = 2 * Math::PI * rand
    @x = 100 * rand
    @y = 100 * rand
    @speed = 10
    @element = nil
    @steeringAngle = 0
    @targetSpeed = 20
    @scanRadius = 20
    @inTraffic = false
  end

  def tick(canvas, cars)
    @x += Math.cos(@direction) * @speed / 10
    @y += Math.sin(@direction) * @speed / 10
    if @x < 0 || @y < 0 || @x > canvas.winfo_width || @y > canvas.winfo_height
      @direction = 2 * Math::PI * rand
      @x = 0 if @x < 0
      @y = 0 if @y < 0
      @x = canvas.winfo_width if @x > canvas.winfo_width
      @y = canvas.winfo_height if @y > canvas.winfo_height
    end
    @direction = (@direction + (@steeringAngle / Math::PI)) % (2*Math::PI)
    @speed += 0.2 if (@speed < @targetSpeed)
    @speed -= 0.8 if (@speed > @targetSpeed)
    inTraffic = false
    cars.each do |car|
      next if car == self
      distance = Math::sqrt(((@x - car.x) ** 2) + ((@y - car.y) ** 2))
      next if distance > @scanRadius
      inTraffic = true
    end
    @steeringAngle = 0.2 if inTraffic && !@inTraffic
    @steeringAngle = 0 if !inTraffic
    @inTraffic = inTraffic
  end

  def render(canvas)
    canvas.delete(@element) if @element
    @element = TkcLine.new(canvas, @x, @y, @x + Math.cos(@direction) * @speed / 10 , @y + Math.sin(@direction) * @speed / 10, :arrow => 'last', :width => 1, :fill => @inTraffic ? :red : :yellow)
  end

end

root = TkRoot.new
root.deiconify
@canvas = TkCanvas.new(root, :bg => 'black', :highlightthickness => 0)
@canvas.pack(:fill => 'both', :expand => 1)

@cars = (1..5).map {Car.new}

def render
  @cars.each do |c|
    c.tick(@canvas, @cars)
    c.render(@canvas)
  end
  Tk.after(25, proc { render } )
end
Tk.after(0, proc { render } )

Tk.mainloop
