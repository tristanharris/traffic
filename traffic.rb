require 'tk'

class Angle

  def initialize(degrees)
    @degrees = degrees
  end

  def degrees
    @degrees
  end

  def radians
    degrees * Math::PI / 180.0
  end

  def set(degrees)
    @degrees = degrees
  end

  def rand!
    @degrees = 360 * rand
  end

  def *(other)
    Angle.new((degrees * other) % 360)
  end

  def +(other)
    other = other.degrees if other.respond_to?(:degrees)
    Angle.new((degrees + other) % 360)
  end

  def cos
    Math.cos(radians)
  end

  def sin
    Math.sin(radians)
  end

end

class Car

  attr_reader :x, :y

  def initialize()
    @direction = Angle.new(0)
    @direction.rand!
    @x = 100 * rand
    @y = 100 * rand
    @speed = 10
    @element = nil
    @steeringAngle = Angle.new(0)
    @targetSpeed = 20
    @scanRadius = 20
    @inTraffic = false
  end

  def tick(canvas, cars)
    @x += @direction.cos * @speed / 10
    @y += @direction.sin * @speed / 10
    if @x < 0 || @y < 0 || @x > canvas.winfo_width || @y > canvas.winfo_height
      @direction.rand!
      @x = 0 if @x < 0
      @y = 0 if @y < 0
      @x = canvas.winfo_width if @x > canvas.winfo_width
      @y = canvas.winfo_height if @y > canvas.winfo_height
    end
    @direction += @steeringAngle
    @speed += 0.2 if (@speed < @targetSpeed)
    @speed -= 0.8 if (@speed > @targetSpeed)
    inTraffic = false
    cars.each do |car|
      next if car == self
      distance = Math::sqrt(((@x - car.x) ** 2) + ((@y - car.y) ** 2))
      next if distance > @scanRadius
      inTraffic = true
    end
    @steeringAngle.set(5) if inTraffic && !@inTraffic
    @steeringAngle.set(0) if !inTraffic
    @inTraffic = inTraffic
  end

  def render(canvas)
    canvas.delete(@element) if @element
    @element = TkcLine.new(canvas, @x, @y, @x + @direction.cos * @speed / 10 , @y + @direction.sin * @speed / 10, :arrow => 'last', :width => 1, :fill => @inTraffic ? :red : :yellow)
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
