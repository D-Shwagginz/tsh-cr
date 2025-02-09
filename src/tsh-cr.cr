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
#  The main project file

require "./engine.cr"

# The "T(hirty) S(ix) H(undered) engine"
module Tsh
  VERSION = "0.1.0"
end

# p_sp1 = [
#   [0, 1, 1, 1],
#   [0, 1, 1, 1],
#   [0, 0, 1],
#   [0, 0, 1],
#   [0, 1, 1, 1],
#   [0, 1, 0, 1],
#   [0, 1, 0, 1],
# ]

# p_sp2 = [
#   [0, 1, 1, 1],
#   [0, 1, 1, 1],
#   [0, 0, 1],
#   [0, 0, 1],
#   [0, 0, 1, 1, 1],
#   [0, 0, 1, 0, 1],
#   [0, 0, 1, 0, 1],
# ]

# p_sp3 = [
#   [0, 1, 1, 1],
#   [0, 1, 1, 1],
#   [0, 0, 1],
#   [0, 0, 1],
#   [1, 1, 1],
#   [1, 0, 1],
#   [1, 0, 1],
# ]

# player = Tsh::PlayThing.new(sprites: [Tsh::Sprite.new(p_sp1), Tsh::Sprite.new(p_sp2), Tsh::Sprite.new(p_sp3)])
# player.flipbook = Tsh::Flipbook.new(0, 2, 1.0)
# player.flipbook.start
# Tsh.background_color = Tsh::BLUE
# Tsh.play("Testing", 50, 50, [Tsh::BLANK, Tsh::WHITE]) do
# end
