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
#  Example of a space invaders type game

require "../src/tsh-cr.cr"

RES_X = 180_u32
RES_Y = 220_u32

PLAYER_SPEED  =  80
MISSILE_SPEED = 120

ALIEN_COLUMNS         = 10
ALIEN_ROWS            =  8
ALIEN_SPACING         =  4
ALIEN_MOVE_DISTANCE_X =  4
ALIEN_MOVE_DISTANCE_Y = 10
ALIEN_MOVE_SPEED      =  2

module PublicVars
  class_property score : Int32 = 0
  class_getter score_nums : Array(Tsh::PlayThing) = [] of Tsh::PlayThing
  class_property missile : Tsh::PlayThing? = nil
  class_getter aliens : Array(Array(Tsh::PlayThing)) = [] of Array(Tsh::PlayThing)
  class_getter alien_die : Tsh::Sound = Tsh::Sound.new(
    [
      Tsh::Sound::Note.new([
        Tsh::Sound::Tone.new(Tsh::Note::C3, Tsh::Sound::Tone::Waveform::Noise),
        Tsh::Sound::Tone.new(Tsh::Note::F3, Tsh::Sound::Tone::Waveform::Square),
      ], 0.1),
      Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::C3, Tsh::Sound::Tone::Waveform::Noise)], 0.08),
    ]
  )
end

numbers = [
  Tsh::Sprite.new([
    [0, 3, 3, 3],
    [3, 0, 0, 0, 3],
    [3, 0, 0, 3, 3],
    [3, 0, 3, 0, 3],
    [3, 3, 0, 0, 3],
    [3, 0, 0, 0, 3],
    [0, 3, 3, 3],
  ]),
  Tsh::Sprite.new([
    [0, 0, 3],
    [0, 3, 3],
    [0, 0, 3],
    [0, 0, 3],
    [0, 0, 3],
    [0, 0, 3],
    [0, 3, 3, 3],
  ]),
  Tsh::Sprite.new([
    [0, 3, 3, 3],
    [3, 0, 0, 0, 3],
    [0, 0, 0, 0, 3],
    [0, 0, 3, 3],
    [0, 3],
    [3],
    [3, 3, 3, 3, 3],
  ]),
  Tsh::Sprite.new([
    [0, 3, 3, 3],
    [3, 0, 0, 0, 3],
    [0, 0, 0, 0, 3],
    [0, 0, 3, 3, 3],
    [0, 0, 0, 0, 3],
    [3, 0, 0, 0, 3],
    [0, 3, 3, 3],
  ]),
  Tsh::Sprite.new([
    [0, 0, 0, 3],
    [0, 0, 3, 3],
    [0, 3, 0, 3],
    [3, 0, 0, 3],
    [3, 3, 3, 3, 3],
    [0, 0, 0, 3],
    [0, 0, 0, 3],
  ]),
  Tsh::Sprite.new([
    [3, 3, 3, 3, 3],
    [3],
    [3, 3, 3, 3],
    [0, 0, 0, 0, 3],
    [0, 0, 0, 0, 3],
    [3, 0, 0, 0, 3],
    [0, 3, 3, 3],
  ]),
  Tsh::Sprite.new([
    [0, 0, 3, 3, 3],
    [0, 3],
    [3],
    [3, 3, 3, 3],
    [3, 0, 0, 0, 3],
    [3, 0, 0, 0, 3],
    [0, 3, 3, 3],
  ]),
  Tsh::Sprite.new([
    [3, 3, 3, 3, 3],
    [0, 0, 0, 0, 3],
    [0, 0, 0, 3],
    [0, 0, 3],
    [0, 3],
    [0, 3],
    [0, 3],
  ]),
  Tsh::Sprite.new([
    [0, 3, 3, 3],
    [3, 0, 0, 0, 3],
    [3, 0, 0, 0, 3],
    [0, 3, 3, 3, 0],
    [3, 0, 0, 0, 3],
    [3, 0, 0, 0, 3],
    [0, 3, 3, 3],
  ]),
  Tsh::Sprite.new([
    [0, 3, 3, 3, 0],
    [3, 0, 0, 0, 3],
    [3, 0, 0, 0, 3],
    [0, 3, 3, 3, 3],
    [0, 0, 0, 0, 3],
    [0, 0, 0, 3],
    [3, 3, 3],
  ]),
]

4.times do |num|
  num = Tsh::PlayThing.new(
    x: RES_X//2 - ((numbers[0].width + 1)*4)//2 + (numbers[0].width + 1) * num,
    y: RES_Y - 20,
    sprites: numbers,
  )
  PublicVars.score_nums << num
end

def add_score(add : Int)
  PublicVars.score += add
  nums = PublicVars.score.to_s.chars.reverse
  if nums.size > PublicVars.score_nums.size
    PublicVars.score_nums.each &.sprite = 8
    return
  end
  nums.each.with_index do |num, i|
    PublicVars.score_nums[-1*(i + 1)].sprite = num - '0'
  end
end

player_sp = Tsh::Sprite.new([
  [0, 0, 0, 0, 0, 1],
  [0, 0, 0, 0, 1, 1, 1],
  [0, 0, 0, 0, 1, 1, 1],
  [0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
])

missile_sp = Tsh::Sprite.new([
  [1],
  [1],
  [1],
])

shoot_sound = Tsh::Sound.new(
  [
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::E2, Tsh::Sound::Tone::Waveform::Noise)], 0.08),
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::C2, Tsh::Sound::Tone::Waveform::Noise)], 0.06),
  ]
)

alien_sprites = [
  Tsh::Sprite.new([
    [0, 0, 2, 0, 0, 0, 0, 0, 2],
    [0, 0, 0, 2, 0, 0, 0, 2],
    [0, 0, 2, 2, 2, 2, 2, 2, 2],
    [0, 2, 2, 0, 2, 2, 2, 0, 2, 2],
    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
    [2, 0, 2, 2, 2, 2, 2, 2, 2, 0, 2],
    [2, 0, 2, 0, 0, 0, 0, 0, 2, 0, 2],
    [0, 0, 0, 2, 2, 0, 2, 2],
  ]),
  Tsh::Sprite.new([
    [0, 0, 2, 0, 0, 0, 0, 0, 2],
    [2, 0, 0, 2, 0, 0, 0, 2, 0, 0, 2],
    [2, 0, 2, 2, 2, 2, 2, 2, 2, 0, 2],
    [2, 2, 2, 0, 2, 2, 2, 0, 2, 2, 2],
    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
    [0, 2, 2, 2, 2, 2, 2, 2, 2, 2],
    [0, 0, 2, 0, 0, 0, 0, 0, 2],
    [0, 2, 0, 0, 0, 0, 0, 0, 0, 2],
  ]),
]

alien_speed = 1.0
alien_direction = 1
aliens_move_time = 1/(ALIEN_MOVE_SPEED*alien_speed)
aliens_levels_moved = 0

ALIEN_ROWS.times do |row|
  array = [] of Tsh::PlayThing
  ALIEN_COLUMNS.times do |column|
    alien = Tsh::PlayThing.new(
      x: column * (alien_sprites[0].width + ALIEN_SPACING) + ((RES_X - (ALIEN_COLUMNS) * (alien_sprites[0].width + ALIEN_SPACING))//2),
      y: row * (alien_sprites[0].height + ALIEN_SPACING) + ((RES_Y - (ALIEN_ROWS) * (alien_sprites[0].height + ALIEN_SPACING))//2 + 34),
      sprites: alien_sprites,
      collision_flags: Tsh::CollisionFlags::Enemy
    )
    alien.flipbook = Tsh::Flipbook.new(0, 1, 1/(ALIEN_MOVE_SPEED*alien_speed))
    alien.flipbook.start
    array << alien
  end
  PublicVars.aliens << array
end

alien_move_sound = Tsh::Sound.new(
  [
    Tsh::Sound::Note.new([Tsh::Sound::Tone.new(Tsh::Note::E1, Tsh::Sound::Tone::Waveform::Square)], 0.05),
  ]
)

player = Tsh::PlayThing.new(
  x: RES_X//2 - player_sp.width//2,
  y: 2,
  sprites: [player_sp]
)

gameover = false
screen_strobe_delay = 0.0

def player_missile_hit(pt : Tsh::PlayThing, other : Tsh::PlayThing)
  if other.collision_flags.includes?(Tsh::CollisionFlags::Enemy)
    PublicVars.alien_die.play
    pt.destroy
    PublicVars.missile = nil
    PublicVars.aliens.each do |row|
      if row.includes?(other)
        row.delete(other)
        PublicVars.aliens.delete(row) if row.empty?
        break
      end
    end
    other.destroy
    add_score(10)
  end
end

Tsh.background_color = Tsh::Color.new(r: 0, g: 80, b: 30, a: 10)
Tsh.play("Space Invaders", RES_X, RES_Y, [Tsh::BLANK, Tsh::GREY, Tsh::GREEN, Tsh::RED]) do
  if !gameover && (PublicVars.aliens.empty? || PublicVars.aliens.reverse[-1][0].y < player.y + player_sp.height)
    gameover = true
    screen_strobe_delay = Tsh.game_time + 1
    PublicVars.aliens.each { |row| row.each &.flipbook.stop }
  end

  if gameover
    if Tsh.game_time > screen_strobe_delay
      screen_strobe_delay = Tsh.game_time + 1
      loop do
        Tsh.background_color = Tsh::Color.new(
          r: Random.new.rand(256),
          g: Random.new.rand(256),
          b: Random.new.rand(256),
          a: 255
        )
        break unless Tsh.colors.includes?(Tsh.background_color)
      end
    end
  else
    right = 0
    right -= PLAYER_SPEED if Tsh.key_down?(Tsh::Key::A)
    right += PLAYER_SPEED if Tsh.key_down?(Tsh::Key::D)
    player.move((player.right_vector.x * right).to_i32, (player.right_vector.y * right).to_i32)
    if PublicVars.missile
      missile = PublicVars.missile.as(Tsh::PlayThing)
      if missile.y + missile_sp.height == RES_Y
        missile.destroy
        PublicVars.missile = nil
      else
        missile.move((missile.up_vector.x * MISSILE_SPEED).to_i32, (missile.up_vector.y * MISSILE_SPEED).to_i32)
      end
    elsif Tsh.key_pressed?(Tsh::Key::Space)
      shoot_sound.play
      PublicVars.missile = Tsh::PlayThing.new(
        x: player.x + player_sp.width//2 - missile_sp.width//2,
        y: player.y + player_sp.height,
        sprites: [missile_sp],
        on_collide_start: ->player_missile_hit(Tsh::PlayThing, Tsh::PlayThing)
      )
    end

    if Tsh.game_time > aliens_move_time
      alien_move_sound.play

      biggest_line = [] of Tsh::PlayThing
      PublicVars.aliens.each do |row|
        biggest_line = row if row.size > biggest_line.size
      end
      collision_alien = biggest_line[(alien_direction == -1 ? 0 : -1)]

      y_move = 0
      # Alien is outside screen
      if (collision_alien.x + collision_alien.sprites[collision_alien.sprite].width +
           ALIEN_MOVE_DISTANCE_X*alien_direction.abs > RES_X) ||
         (collision_alien.x.to_i32 - ALIEN_MOVE_DISTANCE_X*alien_direction.abs < 0)
        # Move down and switch x direction
        y_move = -ALIEN_MOVE_DISTANCE_Y
        alien_direction *= -1
        aliens_levels_moved += 1
        if aliens_levels_moved > 4
          alien_speed *= 2
          PublicVars.aliens.each { |row| row.each &.flipbook.delay = 1/(ALIEN_MOVE_SPEED*alien_speed) }
        end
      end

      # Move aliens
      PublicVars.aliens.each do |row|
        row.each do |alien|
          alien.x += (ALIEN_MOVE_DISTANCE_X*alien_direction).round.to_i32
          alien.y += y_move
        end
      end

      aliens_move_time = Tsh.game_time + 1/(ALIEN_MOVE_SPEED*alien_speed)
    end
  end
end
