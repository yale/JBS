=begin
  Name: My Client
  Assignment: hw2
  Description: Sends input to My Server
  Author: Yale Spector
  Usage: "ruby myclient.rb", "t" for time, "f" for fortune
=end
require 'socket'

tcp_socket = TCPSocket.open('0.0.0.0', 2000)

loop do
  print "> "
  command_string = gets
  break if command_string =~ /^x/
  tcp_socket.puts command_string
  header = tcp_socket.gets
  header.to_i.times do
    puts tcp_socket.gets
  end
end

