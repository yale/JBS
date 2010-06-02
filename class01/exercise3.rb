=begin
  Name:         A Simple Web Server
  Assignment:   hw1.3
  Author:       Yale Spector
  Requirements: Ruby
  Usage:        "ruby exercise3.rb", then type "localhost:2000" into a web browser
=end

require 'socket'               # Get sockets from stdlib
require 'exercise2.rb'         # Import the Fortunes class defined in exercise2

server = TCPServer.open(2000)  # Socket to listen on port 2000
loop {                         # Servers run forever
  client = server.accept       # Wait for a client to connect
  client.puts Time.now.ctime   # Send the time to the client
  fortune = Fortune.new        # Create a new Fortune object
  client.puts fortune.next_fortune # Send a random fortune to the client
  client.puts "Closing the connection. Bye!"
  client.close                 # Disconnect from the client
}
