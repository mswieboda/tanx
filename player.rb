require_relative 'projectile'

class Player
  attr_reader :projectiles, :movement_style

  MOVEMENT_STYLE_TURN = :turn
  MOVEMENT_STYLE_DIRECTIONAL = :directional

  ACCELERATION = 1.25

  def initialize(window)
    @window = window
    @image = Gosu::Image.new("media/tank.png")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @projectiles = []
    @movement_style = MOVEMENT_STYLE_DIRECTIONAL
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

  def face_up
    @angle = 0
  end

  def face_left
    @angle = 270
  end

  def face_right
    @angle = 90
  end

  def face_down
    @angle = 180
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, ACCELERATION / 2)
    @vel_y += Gosu::offset_y(@angle, ACCELERATION / 2)
  end

  def reverse
    @vel_x -= Gosu::offset_x(@angle, ACCELERATION / 2)
    @vel_y -= Gosu::offset_y(@angle, ACCELERATION / 2)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= @window.width
    @y %= @window.height

    # slow down
    @vel_x *= 0.75
    @vel_y *= 0.75

    @projectiles.each(&:move)
    @projectiles.reject!(&:deleted?)
  end

  def shoot
    return if @projectiles.size > 0

    @projectiles << Projectile.new(@window, @x, @y, @angle)
  end

  def draw
    @image.draw_rot(@x, @y, 3, @angle)
    @projectiles.each(&:draw)
  end
end
