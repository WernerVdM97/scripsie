#!/usr/bin/env ruby
require 'io/console'

# ANSI color codes
def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

# Configuration for each window
@windows = [
  { name: "Local Time", time_zone: "local", color: 32, position: 1 },
  { name: "Hong Kong", time_zone: "UTC", color: 34, position: 2 },
  { name: "New York", time_zone: "America/New_York", color: 31, position: 3 },
]

def display_time(terminal_width, terminal_height, top_padding, bottom_padding)
  @windows.each do |window|
    # Calculate the time based on the specified time zone
    current_time = if window[:time_zone] == "local"
                     Time.now.strftime("%H:%M:%S")
                   else
                     "no idea what time it is at #{window[:name]}"
                   end

    # Colorize and format the time
    colored_time = colorize("#{window[:name]}: #{current_time}", window[:color])

    # Calculate the padding for centering
    padding_left = (terminal_width - colored_time.length) / 2

    # Calculate the line for the window taking padding into account
    line = top_padding + window[:position]

    # Move the cursor to the specific line for this window
    print "\e[#{line}H" # Move cursor to the specified line

    # Print the centered time
    print "#{' ' * padding_left}#{colored_time}\r"
  end

  # Print blank lines at the bottom to ensure padding
  print "\e[#{terminal_height - bottom_padding + 1}H"
end

# Ensure the cursor is shown again after the script ends
trap("SIGINT") do
  print "\e[?25h"  # Show the cursor
  exit
end

# Get terminal size
terminal_height, terminal_width = IO.console.winsize

# Define top and bottom padding
top_padding = 2
bottom_padding = 2

# Clear the screen before rendering the first frame
print "\e[H\e[2J"

while true
  # Display each window's time with padding
  display_time(terminal_width, terminal_height, top_padding, bottom_padding)

  sleep 1 # Wait for 1 second
end

# Show the cursor again when the script exits
at_exit { print "\e[?25h" }
