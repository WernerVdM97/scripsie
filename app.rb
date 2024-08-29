#!/usr/bin/env ruby
require 'io/console'

r = Random.new

@block = "\u2588"
@color_codes = {
  black:   30,
  red:     31,
  green:   32,
  yellow:  33,
  blue:    34,
  magenta: 35,
  cyan:    36,
  white:   37,
  b_black:   90,
  b_red:     91,
  b_green:   92,
  b_yellow:  93,
  b_blue:    94,
  b_magenta: 95,
  b_cyan:    96,
  b_white:   97
}

# ANSI color codes
def colorize(text, color_code)
  color_code = @color_codes[color_code] if color_code.is_a?(Symbol)
  "\e[#{color_code}m#{text}\e[0m"
end

# Hide the cursor and clear the screen
print "\e[?25l\e[H\e[2J"

@th, @tw = IO.console.winsize
@th -= 1

# @mask = Array.new(th) { Array.new(tw, 1) }
# @pixels = Array.new(th) { Array.new(tw, ' ') }
@pixels = Array.new(@th) { Array.new(@tw, colorize(@block, :black)) }
fps = 5

# Configuration for each window
@windows = [
  { name: "Local Time", time_zone: "local", color: 32, position: 1 },
  { name: "Hong Kong", time_zone: "UTC", color: 34, position: 2 },
  { name: "New York", time_zone: "America/New_York", color: 31, position: 3 },
]

# Ensure the cursor is shown again after the script ends
trap("SIGINT") do
  print "\e[?25h"  # Show the cursor
  exit
end

def clear
  print "\e[H\e[2J" # Clear the screen and reset cursor
end

# def refresh
#   buffer = "\e[H" # Move cursor to the top-left (home) position
#   @pixels.each do |row|
#     buffer << row.join << "\n"
#   end
#   print buffer  # Move cursor to home and print buffer
# end
def refresh
  print "\e[H" # Move cursor to the top-left (home) position
  @pixels.each_with_index do |row, y|
    row.each_with_index do |pixel, x|
      print "\e[#{y + 1};#{x + 1}H"  # Move cursor to the specific position
      print pixel  # Print the pixel
      sleep 0.001
    end
  end
end

def render(y, x)
  # @pixels[y][x] = colorize(@block, x > @tw/2 ? :red : :blue)
  color = if x > @lw*@tw && y > @ly*@th
            :red
          elsif x > @lw*@tw && y <= @ly*@th
            :blue
          elsif x <= @lw*@tw && y > @ly*@th
            :green
          elsif x <= @lw*@tw && y <= @ly*@th
            :yellow
          end

  pixel = if x > @lw*@tw && y > @ly*@th
            'x' 
          elsif x > @lw*@tw && y <= @ly*@th
            '.' 
          elsif x <= @lw*@tw && y > @ly*@th
            'o' 
          elsif x <= @lw*@tw && y <= @ly*@th
            '+' 
          end

  pixel = @block if [0,@th-1].include?(y) || [0,@tw-1].include?(x)
  @pixels[y][x] = colorize(pixel, color) 
end

while true
  t ||= 0

  # clear
  @th, @tw = IO.console.winsize
  @th -= 1

  # @lw= ((t % 10) / 10.0) * @tw
  @lw= ((Math.sin(Math::PI*t/10.0)+1)/2.0)
  @ly = ((Math.cos(Math::PI*t/10.0)+1)/2.0)

  @pixels.each_with_index { |arr, y| arr.each_with_index { |_, x| render(y, x) } }
 
  # @pixels *= @mask

  refresh
  # puts "t: #{t} \tlimit: #{@lw} \tmodulas: #{t % 10}"
  t += 1
  #sleep 2 # (1/fps).round(3)
end

# Show the cursor again when the script exits
at_exit { print "\e[?25h" }

