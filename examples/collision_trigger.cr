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
#  Example of a invisible trigger box

require "../src/tsh-cr.cr"

RES_X = 30_u32
RES_Y = 30_u32

PLAYER_SPEED =  50
JUMP_POWER   =   2
JUMP_SPEED   = 0.2
FALL_SPEED   =  40

SHOW_TRIGGER = true

module GlobalVars
  class_property colorcube = Tsh::PlayThing.new(
    x: 12,
    y: 20,
    sprites: [
      Tsh::Sprite.new([
        [2, 2, 2, 2, 2],
        [2, 2, 2, 2, 2],
        [2, 2, 2, 2, 2],
        [2, 2, 2, 2, 2],
        [2, 2, 2, 2, 2],
      ]),
      Tsh::Sprite.new([
        [4, 4, 4, 4, 4],
        [4, 4, 4, 4, 4],
        [4, 4, 4, 4, 4],
        [4, 4, 4, 4, 4],
        [4, 4, 4, 4, 4],
      ]),
    ],
  )
end

def player_collide(pt : Tsh::PlayThing, other : Tsh::PlayThing)
  if other.collision_flags.includes?(Tsh::CollisionFlags::Obstacle)
    pt.unmove
  end
end

def trigger(pt : Tsh::PlayThing, other : Tsh::PlayThing)
  if other.collision_flags.includes?(Tsh::CollisionFlags::Player)
    GlobalVars.colorcube.sprite = GlobalVars.colorcube.sprite == 0 ? 1 : 0
  end
end

6.times do |i|
  Tsh::PlayThing.new(
    x: i * 5,
    y: 0,
    sprites: [
      Tsh::Sprite.new([
        [2, 2, 2, 2, 2],
        [2, 3, 2, 3, 2],
        [3, 3, 3, 3, 3],
        [3, 3, 3, 3, 3],
        [3, 3, 3, 3, 3],
      ]),
    ],
    collision_flags: Tsh::CollisionFlags::Obstacle
  )
end

trigger = Tsh::PlayThing.new(
  x: 12,
  y: 5,
  sprites: [
    Tsh::Sprite.new([
      [5, 5, 5, 5, 5],
      [5, 5, 5, 5, 5],
      [5, 5, 5, 5, 5],
      [5, 5, 5, 5, 5],
      [5, 5, 5, 5, 5],
    ]),
  ],
  on_collide_start: ->trigger(Tsh::PlayThing, Tsh::PlayThing),
)

unless SHOW_TRIGGER
  trigger.flags = Tsh::PlayThing::Flags::Invisible
end
trigger = nil

player = Tsh::PlayThing.new(
  x: 4,
  y: 10,
  sprites: [
    Tsh::Sprite.new([
      [1, 1, 1],
      [1, 0, 1],
      [0, 1, 0],
      [1, 0, 1],
      [1, 0, 1],
    ]),
  ],
  on_collide: ->player_collide(Tsh::PlayThing, Tsh::PlayThing),
  collision_flags: Tsh::CollisionFlags::Player)

jumping = false
fall_direction = 1

Tsh.background_color = Tsh::BLUE
Tsh.play("2d Walking", RES_X, RES_Y,
  [Tsh::BLANK, Tsh::WHITE, Tsh::GREEN, Tsh::BROWN, Tsh::RED, Tsh::Color.new(r: 255, g: 255, b: 255, a: 128)]
) do
  right = 0
  if Tsh.key_down?(Tsh::Key::A)
    right -= PLAYER_SPEED
  end
  if Tsh.key_down?(Tsh::Key::D)
    right += PLAYER_SPEED
  end
  player.move((player.right_vector.x * right).to_i32, (player.right_vector.y * right).to_i32)
  Tsh.check_collisions

  if Tsh.key_pressed?(Tsh::Key::Space) && !jumping
    jumping = true
    fall_direction = 0
  end

  if jumping
    if fall_direction > -JUMP_POWER
      fall_direction -= JUMP_SPEED
    else
      jumping = false
    end
  else
    fall_direction += 0.2 if fall_direction < 1
  end

  player.move((-player.up_vector.x * FALL_SPEED * fall_direction).to_i32, (-player.up_vector.y * FALL_SPEED * fall_direction).to_i32)
end
