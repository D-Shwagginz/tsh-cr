# T(wenty) S(ix) H(undered) - CR(ystal)

An easy to use game library focused on creating 2d games
in the style of Atari 2600 games (1977) up to Gameboy games (1989)

## Installation

1. Run your specific platform's install script located in `rsrc/`
   Make sure to run these from inside the tsh-cr repo folder,
   not from inside the `rsrc` folder itself

- If on windows you will need to run these to setup your work environment:
  - Powershell
    ```powershell
    $env:LIB="${env:LIB};C:\tsh-cr"
    $env:PATH="${env:PATH};C:\tsh-cr"
    ```
  - Or cmd
    ```cmd
    set PATH=%PATH%;C:\tsh-cr
    set LIB=%LIB%;C:\tsh-cr
    ```

2. Add `tsh-cr` to your `shard.yml`:
```yml
dependencies:
  tsh-cr:
    github: D-Shwagginz/tsh-cr
```

3. Run `shards update`

## Usage

Tsh-cr uses a class called PlayThings to preform
various game tasks such as managing sprites,
position, animation, as well as collision.

Please visit the examples for a showcase of how to better apply Tsh-cr

### A simple game loop

Tsh-cr's main loop is it's `Tsh.play(title, width, height, colors)` function.<br>
Title will be the title of the window, width and height are the resolutions
of the **internal** screen, not the window itself, and colors is an array
that acts as a palette for all sprites. By default, all colors in the engine are black.

```crystal
require "tsh-cr"

Tsh.play("Hello World!", 50, 50, [Tsh::BLANK, Tsh::WHITE]) do
  # Update code
end
```

### Creating a PlayThing

PlayThings are the basis of Tsh-cr and can be created very simply.

```crystal
Tsh::PlayThing.new(
  x: 12,
  y: 5,
)
```

Now right now this PlayThing will do nothing when `Tsh.play()` is called.
It has no collision callbacks nor any sprites to draw. It will also
never be destroyed since it is not set to a variable or destroyed
in a collision function.<br>

### Drawing a PlayThing

```crystal
smile = Tsh::PlayThing.new(
  sprites: [
    Tsh::Sprite.new([
      [1, 0, 0, 0, 0, 1],
      [0],
      [1, 0, 0, 0, 0, 1],
      [0, 1, 1, 1, 1],
    ]),
  ]
)

Tsh.play("Drawing", 40, 40, [Tsh::BLANK, Tsh::BLUE]) do
end
```

This will create a smiley face in the lower left corner of the
screen since we don't set the PlayThings x or y. Playthings are bottom-left centered,
meaning that all sprites will extend towards the top right.

As you can see, sprites are set as an array in the PlayThing. `Tsh::PlayThing.sprite` is the
current sprite in that array to display. Eacg sprite is an array (rows) of arrays (columns)
of numbers. The numbers map to their respective index in `Tsh.colors` which we set to be blank and blue,
meaning that our smiley face will be shown as blue.

### Making sounds

Tsh-cr uses SunVox to creates it's sounds.

A sound is a collection of notes, which themselves are a collection of tones and the length to play them for.<br>
A tone is a musical note, and the waveform to play it on.

Currently there are 8 waveforms: Triangle, Saw, Square, Noise, Sin, HSin, ASin, and PSin.<br>
The tones in a note can play one musical note on any of these 8 at the same time.

There is currently support for a max of 16 sounds to play at once, with a tone playing on each waveform in
every sound's current note. If you play more than 16 sounds, the oldest sound will be stopped and the new sound
will be played in its place.

```crystal
sound = Tsh::Sound.new(
  [
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::C2, Tsh::Sound::Tone::Waveform::Triangle),
                          Tsh::Sound::Tone.new(Tsh::Note::G4, Tsh::Sound::Tone::Waveform::Noise),
    ], 1.0),
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::F5, Tsh::Sound::Tone::Waveform::Triangle)], 1.0),
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::A3, Tsh::Sound::Tone::Waveform::Square)], 1.0),
  ]
)

sound_played = false

Tsh.play("Sounds", 40, 40) do
  if !sound_played
    sound_played = true
    sound.play
  end
end
```

Playing over 8 tones in one note or playing the same waveform more in more than one tone in a note
will cause unexpected and possibly audio-breaking results. However it is allowed so feel free to experiment.

For something like music which might require multiple of the same waveform, try to use multiple sounds
and treat them as layers. The NES had 5 channels and only 2 of them were the same waveform. If you want
to play tones at times different from others in music, you would also need to use "layered" sounds.

### Examples

In the examples folder you will find ways to use collision, movement,
animation, sound, as well as a simple space invaders clone.

## Contributing

1. Fork it (<https://github.com/D-Shwagginz/tsh-cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Devin Shwagginz](https://github.com/D-Shwagginz) - Creator and maintainer

## Special Thanks

- [raysan5](https://github.com/raysan5) - Creator of Raylib
- [Alexander Zolotov](https://warmplace.ru) - Creator of SunVox
- [Ian Rash](https://github.com/sol-vin) - Created Crystal bindings for SunVox and Raylib