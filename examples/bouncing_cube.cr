require "../src/tsh-cr.cr"

RES_X = 100_u32
RES_Y = 100_u32

cube = Tsh::PlayThing.new(
  x: 50,
  y: 50,
  sprites: [
    Tsh::Sprite.new([
      [1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1],
    ]),
  ])

direction = 1

Tsh.background_color = Tsh::BLUE
Tsh.play("Bouncing Cube", RES_X, RES_Y, [Tsh::BLANK, Tsh::WHITE]) do
  cube.move(direction * 50, 0)
  if cube.x == 0 || cube.x + cube.sprites[cube.sprite].width == RES_X
    direction *= -1
  end
end
