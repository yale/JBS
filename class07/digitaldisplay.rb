=begin
  Name: Digital Display
  Author: Yale Spector
  Description: Displays an integer in "digital clock" format, with variable size
  Usage: "digitaldisplay.rb -s SIZE NUMBER"
=end

require 'optparse'

class DigitalDisplay
  
  attr_reader :output
  
  # Set up our character map. I'm sure this could be more optimized,
  # but this ain't Google Summer of Code.
  CHAR_TO_BIN_MAP = {
    "0" => "010101000101010",
    "1" => "000001000001000",
    "2" => "010001010100010",
    "3" => "010001010001010",
    "4" => "000101010001000",
    "5" => "010100010001010",
    "6" => "010100010101010",
    "7" => "010001000001000",
    "8" => "010101010101010",
    "9" => "010101010001010",
  }
  
  def initialize (input, size=2)
    
    # Ensure that user provided a number
    raise "You must provide something to display!" if not input

    # Set the size as a class variable
    @size = size

    # Convert the input into machine-readable code
    @code = encode input
    
    # Translate the code into an array of characters, each consisting
    # of lines of display code
    @output_characters = @code.map {|char| translate char}
    
    # Finally, loop over the output characters to create a string
    # suitable for display
    @output = prep_for_output @output_characters
    
  end
  
protected
  
  # Converts each character of the user's input into
  # a program-readable binary code
  #
  def encode input
    input.to_s.split(//).map {|n| CHAR_TO_BIN_MAP[n]}.compact
  end
  
  # Converts an encoded character into an array of
  # output-ready lines
  # 
  def translate char
    # Each group of three bits in the encoded string represents
    # an outputted "line" of that character's display.
    # So, create an array of these lines
    lines = char.map { |l| l.scan(/.../) }
    lines.flatten!
    
    # Initialize an empty array to store translated lines
    display_lines = Array.new
    
    # Now, translate and store each line
    lines.each_with_index do |line, i|
      # The line we're on determines our replacement character,
      # as well as whether or not we're repeating the line in
      # our output
      
      # Initalize a blank dislay line to store translated characters
      display_characters = Array.new
      
      # Set the character that maps to 1
      replacement = (i.odd?) ? "|" : "-"
      
      # Now, translate each character
      line.each do |char|
        
      end
      
      # Split the line into bits
      bits = line.split(//)
      
      # For each bit, replace the character, and repeat odd characters @size times
      bits.each_with_index do |bit, j|
        display_characters << (bit == "1" ? replacement : " ") * ((j.odd?) ? @size : 1)
      end
      
      # Flatten the display_line array into one string
      display_line_string = display_characters.join
      
      # Finally, push the line, either once or @size times, into
      # the display_lines array, where it will be ready for output
      ((i.odd?) ? @size : 1).times do
        display_lines << display_line_string
      end
    end
    
    # Return the display_lines array, which holds each printable line
    # of the requested character
    display_lines
  end
  
  # Converts an array of translated characters into an output string
  def prep_for_output chars
    # Initialize an empty string
    output = ""
    
    # Render one horizontal line of output at a time
    # NOTE: There are (@size * 2) + 3 lines
    (@size * 2 + 3).times do |i|
      # Append the ith line of each character to the output string,
      # with spacing proportional to the specified @size
      chars.each do |line|
        output += line[i] += " " * (@size/3+1)
      end
      
      # Done with this line of output; add a newline character to output
      output += "\n"
    end
    
    output
  end 
  
end

# Store the number that is to be displayed
# NOTE: this is either the 1st or 3rd command line argument,
# depending on whether '-s size' is present
number = (ARGV[0] == "-s") ? ARGV[2] : ARGV[0]

# Create a hash to hold command line options
options = {}

# Create an object to parse the -s option
OptionParser.new do |opts|
  opts.on("-s", "--size INT", "Size") do |s|
    options[:size] = s.to_i
  end
end.parse!


# Set a default size
options[:size] ||= 2

# Create a new DigitalDisplay object
display = DigitalDisplay.new(number, options[:size])

# Present result to user
puts display.output