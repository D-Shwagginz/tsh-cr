require "./plaything.cr"
require "./colors.cr"

module Tsh
  # The internal screen's resolution
  class_getter res_x : UInt32 = 0
  class_getter res_y : UInt32 = 0

  # The background color for the screen
  class_property background_color : Raylib::Color = Raylib::BLACK

  alias Key = Raylib::KeyboardKey

  # Checks if a key is currently down
  def self.key_down?(key : Key)
    return Raylib.key_down?(key)
  end

  # Starts the engine.
  # Yields a block to update the game
  def self.play(title : String, @@res_x : UInt32, @@res_y : UInt32, colors : Array(Raylib::Color), &)
    colors.each.with_index do |color, i|
      break if i >= Tsh.colors.size
      Tsh.set_color(i, color)
    end

    Raylib.set_config_flags(Raylib::ConfigFlags::WindowResizable | Raylib::ConfigFlags::VSyncHint)
    Raylib.init_window(640, 480, title)
    Raylib.set_window_min_size(@@res_x, @@res_y)

    screen : Raylib::RenderTexture = Raylib.load_render_texture(@@res_x, @@res_y)
    Raylib.set_texture_filter(screen.texture, Raylib::TextureFilter::Point)

    Raylib.set_target_fps(60)

    while !Raylib.close_window?
      if @@playthings.size > 1
        @@playthings[0..-2].each.with_index do |pt, i|
          next if pt.sprite == -1

          pt_box = Raylib::Rectangle.new(x: pt.x + pt.sprites[pt.sprite].width/2,
            y: pt.y + pt.sprites[pt.sprite].height/2,
            width: pt.sprites[pt.sprite].width,
            height: pt.sprites[pt.sprite].height
          )

          @@playthings[i + 1..].each do |other|
            next if other.sprite == -1

            other_box = Raylib::Rectangle.new(x: other.x + other.sprites[other.sprite].width/2,
              y: other.y + other.sprites[other.sprite].height/2,
              width: other.sprites[other.sprite].width,
              height: other.sprites[other.sprite].height
            )

            if Raylib.check_collision_recs?(pt_box, other_box)
              pt.on_collide.call(pt, other)
              other.on_collide.call(other, pt)
            end
          end
        end
      end

      # Update
      yield

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
  end
end
