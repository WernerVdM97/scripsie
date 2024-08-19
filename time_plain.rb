#!/usr/bin/env ruby

def display_time
  current_time = Time.now.strftime("%H:%M:%S")
  puts "Current time is: #{current_time}"
end

while true
  display_time
  sleep 1
end

