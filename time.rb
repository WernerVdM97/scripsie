require 'artii'

def display_time_in_ascii
  # Get the current time
  current_time = Time.now.strftime("%H:%M:%S")

  # Create a new Artii object
  artii = Artii::Base.new

  # Generate ASCII art for the current time
  ascii_time = artii.asciify(current_time)

  # Print the ASCII art
  puts ascii_time
end

# Run the function
display_time_in_ascii

