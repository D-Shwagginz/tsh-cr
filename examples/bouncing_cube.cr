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
#  Example of a cube bouncing left to right

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
