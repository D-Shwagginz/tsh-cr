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
#  Example of a simple beeps

require "../src/tsh-cr.cr"

RES_X = 100_u32
RES_Y = 100_u32

beeps = Tsh::Sound.new(
  [
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::C3, Tsh::Sound::Tone::Waveform::Triangle)], 1.0),
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::D3, Tsh::Sound::Tone::Waveform::Triangle)], 1.0),
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::E3, Tsh::Sound::Tone::Waveform::Triangle)], 1.0),
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::F3, Tsh::Sound::Tone::Waveform::Triangle)], 1.0),
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::G3, Tsh::Sound::Tone::Waveform::Triangle)], 1.0),
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::A3, Tsh::Sound::Tone::Waveform::Triangle)], 1.0),
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::B3, Tsh::Sound::Tone::Waveform::Triangle)], 1.0),
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::C4, Tsh::Sound::Tone::Waveform::Triangle)], 1.0),
  ]
)

Tsh.background_color = Tsh::BLUE
Tsh.play("Beeps", RES_X, RES_Y, [Tsh::BLANK, Tsh::WHITE]) do
  beeps.play unless beeps.playing
end
