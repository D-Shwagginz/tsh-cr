require "raylib-cr"

module Tsh
  # Color Constants
  LIGHTGRAY  = Raylib::Color.new(r: 200, g: 200, b: 200, a: 255)
  LIGHTGREY  = LIGHTGRAY
  GRAY       = Raylib::Color.new(r: 130, g: 130, b: 130, a: 255)
  GREY       = GRAY
  DARKGRAY   = Raylib::Color.new(r: 80, g: 80, b: 80, a: 255)
  DARKGREY   = DARKGRAY
  YELLOW     = Raylib::Color.new(r: 253, g: 249, b: 0, a: 255)
  GOLD       = Raylib::Color.new(r: 255, g: 203, b: 0, a: 255)
  ORANGE     = Raylib::Color.new(r: 255, g: 161, b: 0, a: 255)
  PINK       = Raylib::Color.new(r: 255, g: 109, b: 194, a: 255)
  RED        = Raylib::Color.new(r: 230, g: 41, b: 55, a: 255)
  MAROON     = Raylib::Color.new(r: 190, g: 33, b: 55, a: 255)
  GREEN      = Raylib::Color.new(r: 0, g: 228, b: 48, a: 255)
  LIME       = Raylib::Color.new(r: 0, g: 158, b: 47, a: 255)
  DARKGREEN  = Raylib::Color.new(r: 0, g: 117, b: 44, a: 255)
  SKYBLUE    = Raylib::Color.new(r: 102, g: 191, b: 255, a: 255)
  BLUE       = Raylib::Color.new(r: 0, g: 121, b: 241, a: 255)
  DARKBLUE   = Raylib::Color.new(r: 0, g: 82, b: 172, a: 255)
  PURPLE     = Raylib::Color.new(r: 200, g: 122, b: 255, a: 255)
  VIOLET     = Raylib::Color.new(r: 135, g: 60, b: 190, a: 255)
  DARKPURPLE = Raylib::Color.new(r: 112, g: 31, b: 126, a: 255)
  BEIGE      = Raylib::Color.new(r: 211, g: 176, b: 131, a: 255)
  BROWN      = Raylib::Color.new(r: 127, g: 106, b: 79, a: 255)
  DARKBROWN  = Raylib::Color.new(r: 76, g: 63, b: 47, a: 255)
  WHITE      = Raylib::Color.new(r: 255, g: 255, b: 255, a: 255)
  BLACK      = Raylib::Color.new(r: 0, g: 0, b: 0, a: 255)
  BLANK      = Raylib::Color.new(r: 0, g: 0, b: 0, a: 0)
  MAGENTA    = Raylib::Color.new(r: 255, g: 0, b: 255, a: 255)
  RAYWHITE   = Raylib::Color.new(r: 245, g: 245, b: 245, a: 255)

  # The amount of colors that can be indexed
  COLOR_COUNT = 32

  alias Color = Raylib::Color
  alias Colors = StaticArray(Color, COLOR_COUNT)

  # A static array of Raylib colors of size *COLOR_COUND*
  class_getter colors : Colors = Colors.new(Raylib::BLACK)

  protected def self.set_color(i : Int, color : Raylib::Color)
    @@colors[i] = color
  end
end
