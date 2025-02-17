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
#  Top level engine stuff (drawing, updating, etc.)

require "./plaything.cr"
require "./colors.cr"
require "./sounds.cr"
require "libsunvox"

module Tsh
  # The internal screen's resolution
  class_getter res_x : UInt32 = 0
  class_getter res_y : UInt32 = 0

  # The background color for the screen
  class_property background_color : Raylib::Color = Raylib::BLACK

  alias Key = Raylib::KeyboardKey

  # Checks if a key is currently down
  def self.key_down?(key : Key) : Bool
    return Raylib.key_down?(key)
  end

  # Checks if a key has been pressed
  def self.key_pressed?(key : Key) : Bool
    return Raylib.key_pressed?(key)
  end

  # Returns the time since the game started
  def self.game_time : Float64
    return Raylib.get_time
  end

  # Returns the time since the last frame rendered
  def self.delta_time : Float64
    return Raylib.get_frame_time
  end

  # Runs all collision checks
  def self.check_collisions
    if @@playthings.size > 1
      # Skip last thing since everything will check against it anyway
      @@playthings[0..-2].each.with_index do |pt, i|
        # Skip if no sprites
        next if pt.sprite == -1

        # PlayThing to check's box
        pt_box = Raylib::Rectangle.new(x: pt.x,
          y: pt.y,
          width: pt.sprites[pt.sprite].width,
          height: pt.sprites[pt.sprite].height
        )

        # Check every other play thing
        @@playthings[i + 1..].each do |other|
          next if other.sprite == -1

          # PlayThing to check against's box
          other_box = Raylib::Rectangle.new(x: other.x,
            y: other.y,
            width: other.sprites[other.sprite].width,
            height: other.sprites[other.sprite].height
          )

          # Overlap?
          if Raylib.check_collision_recs?(pt_box, other_box)
            # Call all collisions
            pt.on_collide.call(pt, other)
            other.on_collide.call(other, pt)

            # If not already colliding, call start collide
            if !pt.colliders.includes?(other)
              pt.colliders << other
              pt.on_collide_start.call(pt, other)
            end
            if !other.colliders.includes?(pt)
              other.colliders << pt
              other.on_collide_start.call(other, pt)
            end
            # Not Overlapping
          else
            # If previously overlapping, call end collide
            if pt.colliders.includes?(other)
              pt.colliders.delete(other)
              pt.on_collide_end.call(pt, other)
            end
            if other.colliders.includes?(pt)
              other.colliders.delete(pt)
              other.on_collide_start.call(other, pt)
            end
          end
        end
      end
    end
  end

  # Starts the engine.
  # Yields a block to update the game
  def self.play(title : String, @@res_x : UInt32, @@res_y : UInt32, colors : Array(Tsh::Color) = [] of Tsh::Color, &)
    colors.each.with_index do |color, i|
      break if i >= Tsh.colors.size
      Tsh.set_color(i, color)
    end

    Raylib.set_trace_log_level(Raylib::TraceLogLevel::Error)
    Raylib.set_config_flags(Raylib::ConfigFlags::WindowResizable | Raylib::ConfigFlags::VSyncHint)
    Raylib.init_window(640, 480, title)
    Raylib.set_window_min_size(@@res_x, @@res_y)

    screen : Raylib::RenderTexture = Raylib.load_render_texture(@@res_x, @@res_y)
    Raylib.set_texture_filter(screen.texture, Raylib::TextureFilter::Point)

    Raylib.set_target_fps(60)

    sound_init()

    while !Raylib.close_window?
      # Sounds
      @@playing_sounds.each { |sound| sound.update }

      # Flipbooks
      @@playthings.each { |pt| pt.flipbook.update if pt.flipbook.active }

      # Update
      yield

      check_collisions

      Tsh.playthings_to_destroy.each { |pt| Tsh.playthings.delete(pt) }
      Tsh.playthings_to_destroy.clear

      # Letter/Pillow boxing scale
      scale_width = Raylib.get_screen_width / @@res_x
      scale_height = Raylib.get_screen_height / @@res_y
      scale = scale_width < scale_height ? scale_width : scale_height

      # Render to internal screen
      Raylib.begin_texture_mode(screen)
      Raylib.clear_background(background_color)
      @@playthings.each &.draw
      Raylib.end_texture_mode

      # Render to window
      Raylib.begin_drawing
      Raylib.clear_background(Raylib::BLACK)

      Raylib.draw_texture_pro(screen.texture, Raylib::Rectangle.new(width: screen.texture.width, height: screen.texture.height),
        Raylib::Rectangle.new(
          x: (Raylib.get_screen_width - (@@res_x * scale))*0.5, y: (Raylib.get_screen_height - (@@res_y*scale))*0.5,
          width: @@res_x*scale, height: @@res_y*scale),
        Raylib::Vector2.new, 0.0, Raylib::WHITE
      )

      Raylib.end_drawing
    end

    Raylib.unload_render_texture(screen)
    Raylib.close_window
    SunVox.stop_engine
  end
end
