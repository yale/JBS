=begin
  Name:         Two Fortunes
  Assignment:   hw1.2
  Author:       Yale Spector
  Requirements: Ruby
  Usage:        "ruby exercise2.rb"
=end

# A class that can return random, non-repeating fortunes
#
class Fortune
  
  # Initialize the @fortunes array
  #
  def initialize
    if File.exists?("fortunes.dump")
      data = File.open("fortunes.dump", "rb") { |file| Marshal.load(file) }
      @fortunes = data[0]
      @read_fortunes = data[1] 
    else
      @fortunes =  ["You will learn Ruby soon",
                    "You will get an A for this course", 
                    "The Redsox will win the superbowl",
                    "You will become very wealthy as a result of the JBS",
                    "You will soon realize the insignificance of your material posessions",
                    "Technology will soon end human suffering",
                    "You will have no trouble completing your homework",
                    "An epic internship is in your future",
                    "Android will overtake iPhone OS in popularity"]
      @read_fortunes = Array.new
    end
  end

  # Return a random fortune and modify fortune_history.txt
  #
  def next_fortune
    # If we've cycled through all of the fortunes...
    if @read_fortunes.length == @fortunes.length
      
      # Shuffle the array, making sure that our next fortune is not the same as our last
      begin
        @fortunes.shuffle!
      end until @fortunes.first != @read_fortunes.last
      
      # Clear our list of read fortunes
      @read_fortunes = []
    end
    
    # Dequeue a fortune
    fortune = @fortunes.shift
    
    # And then push it onto the end of both arrays
    @fortunes << fortune
    @read_fortunes << fortune
    
    # Save our state...
    File.open("fortunes.dump", "wb") { |file| Marshal.dump([@fortunes, @read_fortunes], file) }
    
    # ... and return the fortune
    fortune
  end
end

# If the program is being run from command line
if __FILE__ == $0 
  # Create a new Fortune object
  f = Fortune.new
  
  # Display two random fortunes
  2.times { puts f.next_fortune }
end
    