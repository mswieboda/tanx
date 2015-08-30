require 'pry'

require 'gosu'
require_relative 'player'

class TwoDee < Gosu::Window
  def initialize
    super(Gosu::available_width, Gosu::available_height, false)
    self.caption = 'Tanx'
    # @background_image = Gosu::Image.new("media/space.jpg", tileable: true)

    @player = Player.new(self)
    @player.jump_to(width / 2, height - height / 10)
  end

  def update
    # @player.turn_left if button_down?(Gosu::KbLeft)
    # @player.turn_right if button_down?(Gosu::KbRight)
    @player.accelerate if button_down?(Gosu::KbUp)
    @player.reverse if button_down?(Gosu::KbDown)
    @player.move
  end

  def draw
    @player.draw
    # @background_image.draw(0, 0, 0)
  end

  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    when Gosu::KbLeft
      @player.turn_left
    when Gosu::KbRight
      @player.turn_right
    end
  end
end

window = TwoDee.new
window.show
