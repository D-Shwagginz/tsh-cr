require "./spec_helper"
require "raylib-cr"

describe Tsh do
  it "Should setup and play" do
    Tsh.play("Spec", 100, 100, [] of Tsh::Color) do
      Raylib.close_window
      break
    end
  end

  it "Should run through update and drawing" do
    times_updated = 0
    Tsh.background_color = Tsh::WHITE
    Tsh.play("Spec", 100, 100, [] of Tsh::Color) do
      if times_updated == 1
        Raylib.close_window
        break
      end

      times_updated += 1
    end
  end
end
