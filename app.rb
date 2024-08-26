#!/usr/bin/env ruby
require 'io/console'

r = Random.new

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

th, tw = IO.console.winsize
th = th - 1

# @mask = Array.new(th) { Array.new(tw, 1) }
# @pixels = Array.new(th) { Array.new(tw, ' ') }
@pixels = Array.new(th) { Array.new(tw, colorize("\u2588", :black)) }
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

def refresh
  buffer = "\e[H" # Move cursor to the top-left (home) position
  @pixels.each do |row|
    buffer << row.join << "\n"
  end
  print buffer  # Move cursor to home and print buffer
end

while true
  # clear
  th, tw = IO.console.winsize
  th = th - 1

  @pixels[r.rand(th)][r.rand(tw)] = colorize("\u2588", @color_codes.keys.sample)
  # @pixels = @mask * colorize("\u2588",r.rand(7)+30)
  
  refresh
  sleep 0.01 # (1/fps).round(3)
end

# Show the cursor again when the script exits
at_exit { print "\e[?25h" }

