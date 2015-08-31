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
    @mark_for_deletion = false
    @removed = false
    @armour = 100
    @health = Gosu::Font.new(11)

    @explosion_animation = Gosu::Image::load_tiles("media/explosion.png", 128, 128)
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

  def update
    @x += @vel_x
    @y += @vel_y
    @x %= @window.width
    @y %= @window.height

    # slow down
    @vel_x *= 0.75
    @vel_y *= 0.75

    @projectiles.each(&:update)
    @projectiles.reject!(&:deleted?)
  end

  def shoot
    return if @projectiles.size > 2

    @projectiles << Projectile.new(@window, @x, @y, @angle)
  end

  def check_for_damage(projectiles)
    return if deleted?

    projectiles.each do |projectile|
      if projectile.collide?(@x, @y, 10)
        projectile.mark_for_deletion = true
        @armour -= 10
      end
    end

    @mark_for_deletion = @armour <= 0
  end

  def deleted?
    !!@mark_for_deletion
  end

  def draw
    if deleted?
      # TODO: this needs a lot of work
      # Needs to start at index 0,
      # and only run once, then never show again
      index = Gosu::milliseconds / 100 % @explosion_animation.size
      img = @explosion_animation[index]
      img.draw(@x - img.width / 2.0, @y - img.height / 2.0, 4)

      return
    end

    @image.draw_rot(@x, @y, 3, @angle)
    @health.draw(@armour.to_s, @x, @y, 4)
    @projectiles.each(&:draw)
  end
end
