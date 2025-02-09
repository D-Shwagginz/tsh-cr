require "./engine.cr"

# The "T(hirty) S(ix) H(undered) engine"
module Tsh
  VERSION = "0.1.0"
end

def pickup(pt : Tsh::PlayThing, other : Tsh::PlayThing)
  if other.collision_flags & Tsh::CollisionFlags::Player
    pt.destroy
  end
end

player = Tsh::PT.new(x: 0, y: 0, collision_flags: Tsh::CollisionFlags::Player, sprites: [
  Tsh::Sprite.new([
    [1, 0, 0, 1],
    [0],
    [1, 0, 0, 1],
    [0, 1, 1],
  ]),
])

Tsh::PT.new(x: 20, y: 20, collision_flags: Tsh::CollisionFlags::Pickup,
  on_collide: ->pickup(Tsh::PlayThing, Tsh::PlayThing), sprites: [
  Tsh::Sprite.new([
    [1, 1],
    [1, 1],
  ]),
])

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
