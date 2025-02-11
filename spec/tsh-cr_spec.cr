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
#  Specs for Tsh

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
