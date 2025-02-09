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
#  Everything relating to PlayThings and Sprites

require "raylib-cr"
require "raylib-cr/rlgl"

module Tsh
  alias PT = PlayThing

  @@playthings : Array(PlayThing) = [] of PlayThing

  protected def self.playthings
    @@playthings
  end

  @[Flags]
  enum CollisionFlags
    Player
    Pickup
    Obstacle

    # Custom collision flags
    Custom1
    Custom2
    Custom3
    Custom4
    Custom5
    Custom6
  end

  # A collection of indices to Tsh.color
  struct Sprite
    property data : Array(Array(UInt32)) = [] of Array(UInt32)

    def initialize(sprite : Array(Array(Int)))
      # Converts the given sprite data to UInt32's
      sprite.each do |line|
        current_line = [] of UInt32
        line.each do |num|
          current_line << (num < 0 ? 0_u32 : num.to_u32)
        end
        data << current_line
      end
    end

    def [](x : Int, y : Int)
      return data[y][x]
    end

    # The size of the widest line in the sprite
    def width
      widest = 0
      @data.each do |x|
        widest = x.size > widest ? x.size : widest
      end

      return widest
    end

    # The height of the sprite
    def height
      return @data.size
    end
  end

  # Data for sprite animation
  struct Flipbook
    # The starting frame of the flipbook
    property start_frame : Int32 = 0
    # The ending frame of the flipbook
    property end_frame : Int32 = 0
    # The delay in seconds between frames
    property delay : Float64 = 0.0
    getter current_frame : Int32 = 0
    # Is the flipbook currently going? (Overwrites the PlayThing's *sprite* with *current_frame* if true)
    getter active : Bool = false

    @wait_until : Float64 = 0.0

    def initialize
    end

    def initialize(@start_frame : Int32, @end_frame : Int32, @delay : Float64)
      @current_frame = start_frame
    end

    protected def update
      if Raylib.get_time >= @wait_until
        @current_frame = @current_frame == end_frame ? start_frame : @current_frame + 1
        @wait_until = Raylib.get_time + delay
      end
    end

    # Starts the flipbook and resets the frame and delay
    def start
      if !@active
        @current_frame = start_frame
        @wait_until = Raylib.get_time + delay
        @active = true
      end
    end

    # Starts the flipbook while keeping the current frame and delay difference
    def resume
      if !active
        @wait_until += Raylib.get_time
        @active = true
      end
    end

    # Stops the flipbook and saves the current delay
    def stop
      if @active
        @wait_until -= Raylib.get_time
        @active = false
      end
    end

    # Resets the current frame back to the beginning as well as restarting the delay
    def reset
      @current_frame = start_frame
      @wait_until = Raylib.get_time + delay
    end
  end

  # The generic class for anything in the engine
  class PlayThing
    @[Flags]
    enum Flags
      Invisible

      # Custom flags
      Custom1
      Custom2
      Custom3
      Custom4
      Custom5
      Custom6
    end

    # The flags for the plaything
    property flags : Flags = Flags::None

    # The PlayThing's location. Bottom left centered.
    # All ways to set clamp between 0 and Tsh.res_x/Tsh.res_y
    getter x : UInt32 = 0
    getter y : UInt32 = 0

    # The last position of the PlayThing.
    # Used for undoing a movement.
    @last_x : UInt32 = 0
    @last_y : UInt32 = 0

    # The PlayThing's angle in degrees.
    # 0 points up.
    # All ways to set will keep the value between 0 and 360
    getter angle : Float32 = 0.0

    # The sprite to display from *sprites*
    getter sprite : Int32 = -1
    # An array of all sprites for the PlayThing to display
    getter sprites : Array(Sprite) = [] of Sprite
    # The flipbook to animate the sprites. Will always overwrite *sprite* if active
    property flipbook : Flipbook = Flipbook.new

    # The flags to use for collision detection
    property collision_flags : CollisionFlags = CollisionFlags::None
    # Called when an overlap between this plaything (pt) and another plaything (other) occurs
    property on_collide : Proc(PlayThing, PlayThing, Nil) = ->(pt : PlayThing, other : PlayThing) {}

    def initialize
      Tsh.playthings << self
    end

    def initialize(*, x : Int = 0, y : Int = 0,
                   collision_flags : CollisionFlags = CollisionFlags::None,
                   on_collide : Proc(PlayThing, PlayThing, Nil) = ->(pt : PlayThing, other : PlayThing) {},
                   sprites : Array(Sprite) = [] of Sprite,
                   flags : Flags = Flags::None)
      Tsh.playthings << self
      @collision_flags = collision_flags
      @on_collide = on_collide
      @x = x.to_u32
      @y = y.to_u32
      @last_x = @x
      @last_y = @y
      @sprites = sprites
      @sprite = 0 if @sprites.size > 0
      @flags = flags
    end

    def x=(x : Int)
      @last_x = @x
      @x = x < 0 ? 0_u32 : (x > Tsh.res_x ? Tsh.res_x : x.to_u32)
    end

    def y=(y : Int)
      @last_y = @y
      @y = y < 0 ? 0_u32 : (y > Tsh.res_y ? Tsh.res_y : y.to_u32)
    end

    def angle=(angle : Float32)
      @angle = angle < 0 ? (360 - (angle.abs - (angle.abs // 360) * 360)) : angle - (angle // 360) * 360
    end

    def sprite=(sprite : Int32)
      @sprite = sprite < 0 ? 0 : (sprite >= sprites.size ? sprites.size - 1 : sprite)
    end

    # Moves in x, y direction. X and Y are speeds.
    def move(x : Int, y : Int)
      width = @sprite >= 0 ? @sprites[@sprite].width : 0
      height = @sprite >= 0 ? @sprites[@sprite].height : 0
      x = (x*Raylib.get_frame_time)
      y = (y*Raylib.get_frame_time)
      x = @x.to_f32 + x < 0 || @x.to_f32 + x + width > Tsh.res_x ? 0 : x
      y = @y.to_f32 + y < 0 || @y.to_f32 + y + height > Tsh.res_y ? 0 : y
      @last_x = @x
      @x += x.round.to_i32
      @last_y = @y
      @y += y.round.to_i32
    end

    # Sets the position to the previous x and y values
    def unmove
      @x = @last_x
      @y = @last_y
    end

    # Rotates in *rot* direction, going clockwise
    def rotate(rot : Float32)
      self.angle = @angle + rot * Raylib.get_frame_time
    end

    def destroy
      Tsh.playthings.delete(self)
    end

    def up_vector : Raylib::Vector2
      return Raylib::Vector2.new(x: Math.cos((@angle - 90) * Raylib::DEG2RAD), y: Math.sin((@angle + 90) * Raylib::DEG2RAD))
    end

    def right_vector : Raylib::Vector2
      return Raylib::Vector2.new(x: Math.cos(@angle * Raylib::DEG2RAD), y: Math.sin(@angle * Raylib::DEG2RAD))
    end

    protected def draw
      if flipbook.active
        @sprite = flipbook.current_frame
        @sprite = sprite < 0 ? 0 : (sprite >= sprites.size ? sprites.size - 1 : sprite)
      end

      if sprite >= 0 && (flags & Flags::Invisible).value == 0
        RLGL.push_matrix
        RLGL.translate_f(@x.to_f32 + @sprites[@sprite].width/2, @y.to_f32 + @sprites[@sprite].height/2, 0)
        RLGL.rotate_f(@angle, 0, 0, -1)
        RLGL.translate_f(-@sprites[@sprite].width/2, -@sprites[@sprite].height/2, 0)
        sprites[sprite].data.each.with_index do |line, y|
          line.each.with_index do |color, x|
            color = color >= Tsh.colors.size ? Tsh.colors.size - 1 : color
            Raylib.draw_pixel(x, sprites[sprite].height - y - 1, Tsh.colors[color])
          end
        end
        RLGL.pop_matrix
      end
    end
  end
end
