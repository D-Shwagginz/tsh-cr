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
#  Example of sprite animation

require "../src/tsh-cr.cr"

RES_X = 10_u32
RES_Y = 10_u32

anim1_sp1 = Tsh::Sprite.new([
  [1, 0, 2, 0, 1],
  [0, 1, 0, 2, 0],
  [2, 0, 1, 0, 2],
  [0, 2, 0, 1, 0],
  [1, 0, 2, 0, 1],
])

anim1_sp2 = Tsh::Sprite.new([
  [0, 2, 0, 1, 0],
  [1, 0, 2, 0, 1],
  [0, 1, 0, 2, 0],
  [2, 0, 1, 0, 2],
  [0, 2, 0, 1, 0],
])

anim1 = Tsh::PlayThing.new(
  x: 0,
  y: 2,
  sprites: [
    anim1_sp1,
    anim1_sp2,
  ])

anim1.flipbook = Tsh::Flipbook.new(0, 1, 0.4)
anim1.flipbook.start

anim2_sp1 = Tsh::Sprite.new([
  [1, 1],
  [0, 1],
  [0, 1],
  [0, 1],
  [1, 1, 1],
])

anim2_sp2 = Tsh::Sprite.new([
  [2, 2, 2],
  [0, 0, 0, 2],
  [0, 0, 2],
  [0, 2],
  [2, 2, 2, 2],
])

anim2_sp3 = Tsh::Sprite.new([
  [3, 3, 3],
  [0, 0, 3],
  [3, 3, 3],
  [0, 0, 3],
  [3, 3, 3],
])

anim2_sp4 = Tsh::Sprite.new([
  [4, 0, 4],
  [4, 0, 4],
  [4, 4, 4],
  [0, 0, 4],
  [0, 0, 4],
])

anim2 = Tsh::PlayThing.new(
  x: 6,
  y: 2,
  sprites: [
    anim2_sp1,
    anim2_sp2,
    anim2_sp3,
    anim2_sp4,
  ])

anim2.flipbook = Tsh::Flipbook.new(0, 3, 0.3)
anim2.flipbook.start

Tsh.background_color = Tsh::BLUE
Tsh.play("Flipbook Animation", RES_X, RES_Y, [Tsh::BLANK, Tsh::GREEN, Tsh::RED, Tsh::WHITE, Tsh::PURPLE]) do
  if Tsh.key_pressed?(Tsh::Key::Space)
    if anim1.flipbook.active || anim2.flipbook.active
      anim1.flipbook.stop
      anim2.flipbook.stop
    else
      anim1.flipbook.resume
      anim2.flipbook.resume
    end
  end
end
