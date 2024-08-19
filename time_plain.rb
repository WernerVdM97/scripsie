#!/usr/bin/env ruby

def display_time
  current_time = Time.now.strftime("%H:%M:%S")
  print "\rCurrent time is: #{current_time}" # \r returns the cursor to the beginning of the line
end

while true
  display_time
  sleep 1 # Wait for 1 second
end

