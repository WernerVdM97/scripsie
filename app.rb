#!/usr/bin/env ruby
require 'io/console'
require 'time'  # Needed for time zone handling

# ANSI color codes
def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

# Configuration for each window
windows = [
  { name: "Local Time", time_zone: "local", color: 32, position: 0 },
  { name: "UTC", time_zone: "UTC", color: 34, position: 1 },
  { name: "New York", time_zone: "America/New_York", color: 31, position: 2 },
].freeze

def display_time(terminal_width, terminal_height, window, n)
  # Calculate the time based on the specified time zone
  current_time = if window[:time_zone] == "local"
                   Time.now.strftime("%H:%M:%S")
                 else
                   "wonder what #{window[:name]} like..?"
                 end

  # Colorize and format the time
  colored_time = colorize("#{window[:name]}: #{current_time}", window[:color])

  # Calculate the padding for centering
  padding_left = (terminal_width - colored_time.length) / 2
  padding_top = (terminal_height / n) * window[:position]

  centered_time = ' ' * padding_left + colored_time

  # Print blank lines for vertical spacing
  print "\n" * padding_top

  # Print the centered time
  print "#{centered_time}\r"
end

# Ensure the cursor is shown again after the script ends
trap("SIGINT") do
  print "\e[?25h"  # Show the cursor
  exit
end

while true
  # Get terminal size
  terminal_height, terminal_width = IO.console.winsize

  # Clear the screen and hide the cursor
  print "\e[H\e[2J\e[?25l"

  # Display each window's time
  windows.each do |window|
    display_time(terminal_width, terminal_height, window, window.size)
  end

  sleep 1 # Wait for 1 second
end

# Show the cursor again when the script exits
at_exit { print "\e[?25h" }

