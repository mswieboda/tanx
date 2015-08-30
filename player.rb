require 'pry'

class Player
  attr_reader :window

  AMOUNT = 0.5

  def initialize(window)
    @window = window

    @image = Gosu::Image.new(window, "media/fighter.jpg", false)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
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

  # def left
  #   @vel_x -= AMOUNT
  # end

  # def right
  #   @vel_x += AMOUNT
  # end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, AMOUNT / 2)
    @vel_y += Gosu::offset_y(@angle, AMOUNT / 2)
  end

  def reverse
    @vel_x -= Gosu::offset_x(@angle, AMOUNT / 2)
    @vel_y -= Gosu::offset_y(@angle, AMOUNT / 2)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= window.width
    @y %= window.height

    # slow down
    @vel_x *= 0.9
    @vel_y *= 0.9
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end
