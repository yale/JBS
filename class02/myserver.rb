=begin
  Name: My Server
  Assignment: hw2
  Description: A web server on port 8888.
  Author: Yale Spector
  Usage: "ruby myserver.rb"
=end

require 'gserver'

FORTUNES = ["You will learn a lot",
            "You will get an 'A",
            "You still have much to learn, Grasshopper"]

JOKES =    ["Q: Why did the chicken cross the road?\nA: To get to the other side.",
            "Q: Did you hear about the constipated mathematician?\nA: He worked it out with a pencil.",
            "Q: How did Batman get Robin to get into the Batmobile?\nA: He said \"Get into the Batmobile, Robin.\""]

class MyServer < GServer
  def initialize(*args)
    super(*args)    
    @@client_id = 0
  end
  
  def serve(io_object)
    
    # This line automatically increments the GServer class variable "@@client_id", so that
    # each connection is associated with a unique integer
    @@client_id += 1
    
    # Set my_client_id to the incremented value
    my_client_id = @@client_id
    
    io_object.sync = true
    
    puts "Client #{@@client_id} attached at #{Time.now}."
    
    # Respond to user input
    loop do
      
      # Read user input
      line = io_object.readline
      
      # Initialize the content
      content = ""
      
      case line
        
      # If the input begins with an x, exit the loop
      when /^x/
        puts "Exiting!"
        break
      
      # If the input begins with an f, display a random fortune
      when /^f/
        puts "Fortune requested at #{Time.now}"
        content << FORTUNES[FORTUNES.length * rand] # line 26
        
      # If the input equals "date", display today's date
        
      # If the input is of the form dfilename.ext, read out the file filename.ext
      when /^d[^\.]+\.[^\.\/]+/
        
        # Strip leading "d" from filename
        filename = line[1..-1].chomp
        
        puts "#{filename} requested at #{Time.now}"
        
        # Make sure the file exists
        if File.exists?(filename)
          
          # Load the file
          file = File.open(filename, "r").each do |line|
            
            # Send the file to io buffer line by line
            content << line
            
          end
          file.close
        else
          content << "Invalid file name. Try again."
        end
        
      # Match strings that look like a relative URL path with one optional argument
      when /(\w+)((\/\w+)+)?(\?(\w+)=(\w+))?/
        urlarray = /(\w+)((\/\w+)+)?(\?(\w+)=(\w+))?/.match(line)
        
        # Extract the controller
        path = [urlarray[1]]
        
        # Extract the arguments
        path += urlarray[2].split("/")[1..-1] if urlarray[2]
        
        # Extract the optional GET argument
        optarg, optval = urlarray[5], urlarray[6] 
        
        # Run the appropriate controller
        case path[0]
        when "message"
          
          puts "Message requested at #{Time.now}"
          # Display a message of the requested type
          
          case path[1]
          when "fortune"
            content << FORTUNES[FORTUNES.length * rand]
          when "joke"
            content << JOKES[JOKES.length * rand]
          when nil
            content << "Please clarify what kind of message you would like."
          else
            content << "Dude, what kind of message is a #{path[1]}?"
          end
        
        when "date"
          puts "Date requested at #{Time.now}"
          content << "The date is #{Time.now.strftime("%m/%D/%Y")}"
        when "time"
          puts "Time requested at #{Time.now}"
          content << "The time of day is #{Time.now.strftime("%I:%M%p")}"
        else
          puts "Received invalid URL: #{line.chomp}, at #{Time.now}"
          content << "Sorry, we don't know what to do with that."
        end
        
        # If an argument was set in the URL, display it
        content << "\n#{optarg}: #{optval}" if optarg and optval
        
      else
        puts "Received invalid line: #{line.chomp}, at #{Time.now}"
        content << "What does #{line.chomp} mean anyway?"
      end
      
      # construct a header containing the number of lines in the content
      header = content.lines.count
      
      # send the header and the content to the client
      io_object.puts header
      io_object.puts content
    end
  end
end

puts "Starting to listen for a connection on port 2000"
server = MyServer.new(2000)
server.start
server.join