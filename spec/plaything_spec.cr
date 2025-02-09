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
#  Specs for PlayThings and Sprites

require "./spec_helper"
require "raylib-cr"

describe Tsh::PlayThing do
  it "Should create a plaything and destroy it", tags: "gh-actions" do
    pt = Tsh::PlayThing.new
    pt.destroy
  end

  it "Should clamp position" do
    pt = Tsh::PlayThing.new(x: 10, y: 2)

    times_updated = 0
    Tsh.play("Spec", 100, 100, [] of Tsh::Color) do
      case times_updated
      when 0
        pt.x = 15
        pt.y = 8
        pt.x.should eq 15
        pt.y.should eq 8
      when 1
        pt.x = 150
        pt.y = 205
        pt.x.should eq 100
        pt.y.should eq 100
      when 2
        pt.x = -69
        pt.y = -420
        pt.x.should eq 0
        pt.y.should eq 0
      when 3
        pt.destroy
        Raylib.close_window
        break
      end

      times_updated += 1
    end
  end

  it "Should reset angle every 360" do
    pt = Tsh::PlayThing.new

    times_updated = 0
    Tsh.play("Spec", 100, 100, [] of Tsh::Color) do
      case times_updated
      when 0
        pt.angle = 1
        pt.angle.should eq 1
      when 1
        pt.angle = 361
        pt.angle.should eq 1
      when 2
        pt.angle = -200
        pt.angle.should eq 160
      when 3
        pt.angle = -361
        pt.angle.should eq 359
      when 4
        pt.destroy
        Raylib.close_window
        break
      end

      times_updated += 1
    end
  end

  it "Should draw sprite and test colors" do
    pt = Tsh::PlayThing.new(sprites: [Tsh::Sprite.new([[1, 1], [1, 0, 1, 1], [1]])])

    pt.sprites[pt.sprite].width.should eq 4
    pt.sprites[pt.sprite].height.should eq 3

    times_updated = 0
    Tsh.play("Spec", 100, 100, [Tsh::BLANK, Tsh::WHITE] of Tsh::Color) do
      case times_updated
      when 0
        Tsh.colors[1].should eq Tsh::WHITE
        Tsh.colors[2].should eq Tsh::BLACK

        expect_raises(IndexError) do
          Tsh.colors[Tsh::COLOR_COUNT]
        end
      when 1
        pt.destroy
        Raylib.close_window
        break
      end

      times_updated += 1
    end
  end

  it "Should collide" do
    collided = false
    pt1 = Tsh::PlayThing.new(sprites: [Tsh::Sprite.new([[1]])], collision_flags: Tsh::CollisionFlags::Player)
    pt2 = Tsh::PlayThing.new(sprites: [Tsh::Sprite.new([[1]])], on_collide: ->(pt : Tsh::PlayThing, other : Tsh::PlayThing) { collided = true if other.collision_flags.includes(Tsh::CollisionFlags::Player) })

    times_updated = 0
    Tsh.play("Spec", 100, 100, [] of Tsh::Color) do
      case times_updated
      when 1
        collided.should be_true
      when 2
        pt1.destroy
        pt2.destroy
        Raylib.close_window
        break
      end

      times_updated += 1
    end
  end

  it "Shouldn't collide" do
    collided = false
    pt1 = Tsh::PlayThing.new(sprites: [Tsh::Sprite.new([[1]])], collision_flags: Tsh::CollisionFlags::Pickup)
    pt2 = Tsh::PlayThing.new(sprites: [Tsh::Sprite.new([[1]])], on_collide: ->(pt : Tsh::PlayThing, other : Tsh::PlayThing) { collided = true if other.collision_flags.includes(Tsh::CollisionFlags::Player) })

    times_updated = 0
    Tsh.play("Spec", 100, 100, [] of Tsh::Color) do
      case times_updated
      when 1
        collided.should be_false
      when 2
        pt1.destroy
        pt2.destroy
        Raylib.close_window
        break
      end

      times_updated += 1
    end
  end

  it "Flipbook should flip correctly" do
    pt = Tsh::PlayThing.new(sprites: [
      Tsh::Sprite.new([[1]]),
      Tsh::Sprite.new([[0]]),
    ])

    pt.flipbook = Tsh::Flipbook.new(0, 1, 0.1)

    times_updated = 0
    Tsh.play("Spec", 100, 100, [] of Tsh::Color) do
      case times_updated
      when 1
        pt.flipbook.start
        Raylib.wait_time(0.1)
      when 2
        pt.flipbook.current_frame.should eq 1
        Raylib.wait_time(0.1)
      when 3
        pt.flipbook.current_frame.should eq 0
      when 4
        pt.flipbook.stop
        Raylib.wait_time(0.1)
      when 5
        pt.flipbook.current_frame.should eq 0
      when 6
        pt.destroy
        Raylib.close_window
        break
      end

      times_updated += 1
    end
  end
end
