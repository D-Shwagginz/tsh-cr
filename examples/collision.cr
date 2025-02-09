# Copyright 2025 Devin Shwagginz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# DESCRIPTION :
#  Example of collisions

require "../src/tsh-cr.cr"

RES_X = 100_u32
RES_Y = 100_u32

sprites = [
  Tsh::Sprite.new([
    [2, 2, 2, 2, 2],
    [2, 2, 2, 2, 2],
    [2, 2, 2, 2, 2],
    [2, 2, 2, 2, 2],
    [2, 2, 2, 2, 2],
  ]),
  Tsh::Sprite.new([
    [3, 3, 3, 3, 3],
    [3, 3, 3, 3, 3],
    [3, 3, 3, 3, 3],
    [3, 3, 3, 3, 3],
    [3, 3, 3, 3, 3],
  ]),
]

def collision(pt : Tsh::PlayThing, other : Tsh::PlayThing)
  if other.collision_flags.includes?(Tsh::CollisionFlags::Obstacle)
    pt.sprite = pt.sprite == 0 ? 1 : 0
  end
end

Tsh::PlayThing.new(
  x: 20,
  y: 52,
  sprites: sprites,
  on_collide_start: ->collision(Tsh::PlayThing, Tsh::PlayThing) # Only calls when a collision starts
)

Tsh::PlayThing.new(
  x: 80,
  y: 52,
  sprites: sprites,
  on_collide_start: ->collision(Tsh::PlayThing, Tsh::PlayThing), # Calls when the collision starts
  on_collide_end: ->collision(Tsh::PlayThing, Tsh::PlayThing)    # And when it ends
)

Tsh::PlayThing.new(
  x: 50,
  y: 52,
  sprites: sprites,
  on_collide: ->collision(Tsh::PlayThing, Tsh::PlayThing), # Calls every frame that a collision occurs
)

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
  ],
  collision_flags: Tsh::CollisionFlags::Obstacle)

direction = 1

Tsh.background_color = Tsh::BLUE
Tsh.play("Collision", RES_X, RES_Y, [Tsh::BLANK, Tsh::WHITE, Tsh::GREEN, Tsh::RED]) do
  cube.move(direction * 50, 0)
  if cube.x == 0 || cube.x + cube.sprites[cube.sprite].width == RES_X
    direction *= -1
  end
end
