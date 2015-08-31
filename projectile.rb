class Projectile
  ACCELERATION = 10

  attr_accessor :mark_for_deletion

  def initialize(window, x, y, angle)
    @window = window
    @image = Gosu::Image.new("media/projectile.png")
    @vel_x = @vel_y = 0.0
    @x = x
    @y = y
    @angle = angle
    @mark_for_deletion = false

    accelerate
  end

  def jump_to(x, y)
    @x = x
    @y = y
  end

  def turn(angle)
    @angle += angle
  end

  def turn_left
    turn(-90)
  end

  def turn_right
    turn(90)
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, ACCELERATION)
    @vel_y += Gosu::offset_y(@angle, ACCELERATION)
  end

  def update
    @x += @vel_x
    @y += @vel_y

    if @x >= @window.width || @x <= 0 || @y >= @window.height || @y <= 0
      @mark_for_deletion = true
    end
  end

  def deleted?
    !!@mark_for_deletion
  end

  def collide?(x, y, size)
    Gosu::distance(@x, @y, x, y) < size
  end

  def draw
    @image.draw_rot(@x, @y, 2, @angle)
  end
end
