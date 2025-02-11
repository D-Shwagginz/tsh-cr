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
#  All audio and sound related stuff

require "libsunvox"
require "raylib-cr"

module Tsh
  # The maximum amount of sound that can play at the same time. 1-16
  MAX_SOUNDS = 16

  alias Note = SunVox::Note

  @@slot : SunVox::Slot = SunVox::Slot::Zero

  @@generators : Array(Int32) = [] of Int32
  @@open_tracks : Array(Bool) = Array.new(MAX_SOUNDS, true)

  @@playing_sounds : Array(Sound) = [] of Sound

  protected def self.slot
    @@slot
  end

  protected def self.generators
    @@generators
  end

  protected def self.open_tracks
    @@open_tracks
  end

  protected def self.playing_sounds
    @@playing_sounds
  end

  # A collection of note data which can be played.
  # Currently you can play a Tone on every waveform at once,
  # giving the ability to play 8 different sounding musical notes
  # at the same time.
  # Attemps to play multiple notes on the same waveform at 
  # the same time in one sound will yield unexpected results.
  class Sound
    # A musical note and the waveform to play it on
    struct Tone
      # The waveform to play the musical note on
      enum Waveform
        Triangle
        Saw
        Square
        Noise
        Sin
        HSin
        ASin
        PSin
      end

      # The musical note to play
      property note : Tsh::Note
      # The waveform to play it on
      property waveform : Waveform

      def initialize(@note : Tsh::Note, @waveform : Waveform)
      end
    end

    # A collection of tones with a length to play them for
    struct Note
      # The tones to play
      property tones : Array(Tone)
      # How long to play them for
      property length : Float64

      def initialize(@tones : Array(Tone), @length : Float64)
      end
    end

    # The notes for the sound to play
    getter notes : Array(Note) = [] of Note
    # Is the sound currently playing?
    getter playing : Bool = false
    # Loop the sound
    property looping : Bool = false
    @wait_time : Float64 = 0.0
    @current_note : Int32 = 0
    @track : Int32 = -1

    def initialize(@notes : Array(Note), looping : Bool = false)
      @looping = looping
    end

    protected def track
      @track
    end

    # Play the sound from the beginning
    def play
      if notes.size > 0 && !Tsh.playing_sounds.includes?(self)
        Tsh.open_tracks.each.with_index do |is_open, track|
          if is_open
            @track = track
            Tsh.open_tracks[track] = false
            break
          end
        end

        if @track == -1
          @track = Tsh.playing_sounds[0].track
          Tsh.playing_sounds[0].stop
          Tsh.open_tracks[@track] = false
        end

        Tsh.playing_sounds << self
        @current_note = 0
        notes[@current_note].tones.each do |tone|
          SunVox.send_event(Tsh.slot, @track, tone.note, 0, Tsh.generators[tone.waveform.value])
        end
        @wait_time = Raylib.get_time + notes[@current_note].length
        @playing = true
      end
    end

    # Stop the sound
    def stop
      Tsh.open_tracks[@track] = true
      Tsh.playing_sounds.delete(self)
      @wait_time -= Raylib.get_time
      @playing = false
    end

    # Resume the sound from where it was stopped
    def resume
      if notes.size > 0 && !Tsh.playing_sounds.includes?(self)
        Tsh.open_tracks.each.with_index do |is_open, track|
          if is_open
            @track = track
            Tsh.open_tracks[track] = false
            break
          end
        end

        if @track == -1
          @track = Tsh.playing_sounds[0].track
          Tsh.playing_sounds[0].stop
          Tsh.open_tracks[@track] = false
        end

        Tsh.playing_sounds << self
        notes[@current_note].tones.each do |tone|
          SunVox.send_event(Tsh.slot, @track, tone.note, 0, Tsh.generators[tone.waveform.value])
        end
        @wait_time += Raylib.get_time
        @playing = true
      end
    end

    protected def update
      if Raylib.get_time >= @wait_time
        notes[@current_note].tones.each do |tone|
          SunVox.send_event(Tsh.slot, @track, Tsh::Note::Off, 0, Tsh.generators[tone.waveform.value])
        end
        @current_note += 1

        if @current_note == notes.size
          @current_note = 0
          if !looping
            stop
            return
          end
        end
        notes[@current_note].tones.each do |tone|
          SunVox.send_event(Tsh.slot, @track, tone.note, 0, Tsh.generators[tone.waveform.value])
        end
        @wait_time = Raylib.get_time + notes[@current_note].length
      end
    end
  end

  # Internal sound initialization
  protected def self.sound_init
    SunVox.start_engine(config: "buffer=1280", no_debug_output: true, one_thread: true)
    @@slot = SunVox.open_slot(SunVox::Slot::Zero)

    8.times do |i|
      @@generators << SunVox.new_module(@@slot, SunVox::Modules::Synths::GENERATOR)
      SunVox.connect_module(@@slot, @@generators[i], SunVox::OUTPUT_MODULE)
      waveform = i > 3 ? i + 1 : i # Skip over 4 (drawn)
      SunVox.send_event(@@slot, 0, SunVox::Note::None, 0, @@generators[i], ctl: 2, ctl_value: waveform)
      SunVox.send_event(@@slot, 0, SunVox::Note::None, 0, @@generators[i], ctl: 6, ctl_value: MAX_SOUNDS)
    end
  end
end
