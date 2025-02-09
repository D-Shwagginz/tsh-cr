require "./engine.cr"

# The "T(hirty) S(ix) H(undered) engine"
module Tsh
  VERSION = "0.1.0"
end

p_sp1 = [
  [0, 1, 1, 1],
  [0, 1, 1, 1],
  [0, 0, 1],
  [0, 0, 1],
  [0, 1, 1, 1],
  [0, 1, 0, 1],
  [0, 1, 0, 1],
]

p_sp2 = [
  [0, 1, 1, 1],
  [0, 1, 1, 1],
  [0, 0, 1],
  [0, 0, 1],
  [0, 0, 1, 1, 1],
  [0, 0, 1, 0, 1],
  [0, 0, 1, 0, 1],
]

p_sp3 = [
  [0, 1, 1, 1],
  [0, 1, 1, 1],
  [0, 0, 1],
  [0, 0, 1],
  [1, 1, 1],
  [1, 0, 1],
  [1, 0, 1],
]

player = Tsh::PlayThing.new(sprites: [Tsh::Sprite.new(p_sp1), Tsh::Sprite.new(p_sp2), Tsh::Sprite.new(p_sp3)])
player.flipbook = Tsh::Flipbook.new(0, 2, 1.0)
player.flipbook.start
Tsh.background_color = Tsh::BLUE
Tsh.play("Testing", 50, 50, [Tsh::BLANK, Tsh::WHITE]) do
end
