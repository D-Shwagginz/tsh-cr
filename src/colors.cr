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
#  Color constants, aliases, and the colors used by sprites

require "raylib-cr"

module Tsh
  # Color Constants

  # :nodoc:
  LIGHTGRAY = Raylib::Color.new(r: 200, g: 200, b: 200, a: 255)
  # :nodoc:
  LIGHTGREY = LIGHTGRAY
  # :nodoc:
  GRAY = Raylib::Color.new(r: 130, g: 130, b: 130, a: 255)
  # :nodoc:
  GREY = GRAY
  # :nodoc:
  DARKGRAY = Raylib::Color.new(r: 80, g: 80, b: 80, a: 255)
  # :nodoc:
  DARKGREY = DARKGRAY
  # :nodoc:
  YELLOW = Raylib::Color.new(r: 253, g: 249, b: 0, a: 255)
  # :nodoc:
  GOLD = Raylib::Color.new(r: 255, g: 203, b: 0, a: 255)
  # :nodoc:
  ORANGE = Raylib::Color.new(r: 255, g: 161, b: 0, a: 255)
  # :nodoc:
  PINK = Raylib::Color.new(r: 255, g: 109, b: 194, a: 255)
  # :nodoc:
  RED = Raylib::Color.new(r: 230, g: 41, b: 55, a: 255)
  # :nodoc:
  MAROON = Raylib::Color.new(r: 190, g: 33, b: 55, a: 255)
  # :nodoc:
  GREEN = Raylib::Color.new(r: 0, g: 228, b: 48, a: 255)
  # :nodoc:
  LIME = Raylib::Color.new(r: 0, g: 158, b: 47, a: 255)
  # :nodoc:
  DARKGREEN = Raylib::Color.new(r: 0, g: 117, b: 44, a: 255)
  # :nodoc:
  SKYBLUE = Raylib::Color.new(r: 102, g: 191, b: 255, a: 255)
  # :nodoc:
  BLUE = Raylib::Color.new(r: 0, g: 121, b: 241, a: 255)
  # :nodoc:
  DARKBLUE = Raylib::Color.new(r: 0, g: 82, b: 172, a: 255)
  # :nodoc:
  PURPLE = Raylib::Color.new(r: 200, g: 122, b: 255, a: 255)
  # :nodoc:
  VIOLET = Raylib::Color.new(r: 135, g: 60, b: 190, a: 255)
  # :nodoc:
  DARKPURPLE = Raylib::Color.new(r: 112, g: 31, b: 126, a: 255)
  # :nodoc:
  BEIGE = Raylib::Color.new(r: 211, g: 176, b: 131, a: 255)
  # :nodoc:
  BROWN = Raylib::Color.new(r: 127, g: 106, b: 79, a: 255)
  # :nodoc:
  DARKBROWN = Raylib::Color.new(r: 76, g: 63, b: 47, a: 255)
  # :nodoc:
  WHITE = Raylib::Color.new(r: 255, g: 255, b: 255, a: 255)
  # :nodoc:
  BLACK = Raylib::Color.new(r: 0, g: 0, b: 0, a: 255)
  # :nodoc:
  BLANK = Raylib::Color.new(r: 0, g: 0, b: 0, a: 0)
  # :nodoc:
  MAGENTA = Raylib::Color.new(r: 255, g: 0, b: 255, a: 255)
  # :nodoc:
  RAYWHITE = Raylib::Color.new(r: 245, g: 245, b: 245, a: 255)

  # The size of `Tsh.colors`
  COLOR_COUNT = 32

  # :nodoc:
  alias Color = Raylib::Color
  # :nodoc:
  alias Colors = StaticArray(Color, COLOR_COUNT)

  # A static array of `Tsh::Color` of size `COLOR_COUNT`
  class_getter colors : Colors = Colors.new(Raylib::BLACK)

  # Sets a color in *colors*. Needed because static arrays can not be passed through a function
  protected def self.set_color(i : Int, color : Raylib::Color)
    @@colors[i] = color
  end
end
