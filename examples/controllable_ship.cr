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
#  Example of a player controlled ship

require "../src/tsh-cr.cr"

RES_X = 200_u32
RES_Y = 200_u32

PLAYER_SPEED      =     150
PLAYER_TURN_SPEED = 400_f32

ship = Tsh::PlayThing.new(
  x: 50,
  y: 50,
  sprites: [
    Tsh::Sprite.new([
      [0, 0, 1, 1],
      [0, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1],
      [0, 1, 1, 1, 1],
    ]),
  ])

direction = 1

Tsh.background_color = Tsh::BLUE
Tsh.play("Controllable Ship", RES_X, RES_Y, [Tsh::BLANK, Tsh::WHITE]) do
  forward = 0
  if Tsh.key_down?(Tsh::Key::W)
    forward += PLAYER_SPEED
  end
  if Tsh.key_down?(Tsh::Key::S)
    forward -= PLAYER_SPEED
  end
  ship.move((ship.forward_vector.x * forward).to_i32, (ship.forward_vector.y * forward).to_i32)

  if Tsh.key_down?(Tsh::Key::A)
    ship.rotate(-PLAYER_TURN_SPEED)
  end
  if Tsh.key_down?(Tsh::Key::D)
    ship.rotate(PLAYER_TURN_SPEED)
  end
end
