require "./engine.cr"

# The "T(hirty) S(ix) H(undered) engine"
module Tsh
  VERSION = "0.1.0"
end

player = Tsh::PT.new(0, 0, Tsh::Sprite.new([
  [1, 0, 0, 1],
  [0],
  [1, 0, 0, 1],
  [0, 1, 1],
]))

Tsh.background_color = Raylib::BLUE
Tsh.play("Test", 40, 40, [Raylib::BLANK, Raylib::WHITE]) do
  x_velocity = 0
  y_velocity = 0
  if Tsh.key_down?(Tsh::Key::W)
    y_velocity += 50
  end
  if Tsh.key_down?(Tsh::Key::S)
    y_velocity -= 50
  end
  if Tsh.key_down?(Tsh::Key::A)
    x_velocity -= 50
  end
  if Tsh.key_down?(Tsh::Key::D)
    x_velocity += 50
  end
  if Tsh.key_down?(Tsh::Key::Q)
    player.rotate(-400)
  end
  if Tsh.key_down?(Tsh::Key::E)
    player.rotate(400)
  end

  player.move(x_velocity, y_velocity)
end
