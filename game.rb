require 'gosu'
require_relative 'player'

class Tanx < Gosu::Window
  def initialize
    super(Gosu::available_width, Gosu::available_height, false)
    self.caption = 'Tanx'
    @background_image = Gosu::Image.new("media/space.jpg", tileable: true)

    @player = Player.new(self)
    @player.jump_to(width / 2, height - height / 10)
  end

  def update
    if @player.movement_style == Player::MOVEMENT_STYLE_DIRECTIONAL
      if button_down?(Gosu::KbUp) || button_down?(Gosu::KbLeft) || button_down?(Gosu::KbRight) || button_down?(Gosu::KbDown)
        @player.accelerate
      end
    elsif @player.movement_style == Player::MOVEMENT_STYLE_TURN
      if button_down?(Gosu::KbUp)
        @player.accelerate
      elsif button_down?(Gosu::KbDown)
        @player.reverse
      end
    end

    @player.move
  end

  def draw
    @player.draw
    @background_image.draw(0, 0, 0, 5, 5)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
      return
    end

    @player.shoot if id == Gosu::KbSpace

    if @player.movement_style == Player::MOVEMENT_STYLE_DIRECTIONAL
      case id
      when Gosu::KbUp
        @player.face_up
      when Gosu::KbLeft
        @player.face_left
      when Gosu::KbRight
        @player.face_right
      when Gosu::KbDown
        @player.face_down
      end
    elsif @player.movement_style == Player::MOVEMENT_STYLE_TURN
      case id
      when Gosu::KbLeft
        @player.turn_left
      when Gosu::KbRight
        @player.turn_right
      end
    end
  end
end

window = Tanx.new
window.show
