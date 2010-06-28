require 'rubygems'
require 'httparty'

class CardUtil
  include HTTParty
  base_uri 'localhost:3000'
  
  # As written by Pito
  #
  def change(cardnum, text)
    options = {:query => {:card => {:name => text}}}
    self.class.get("/cards/#{cardnum}/store.xml", options)
  end
  
  # Add
  # Sends a post request to cards.xml with user-provided data
  #
  def add(name, home_phone = nil, office_phone = nil)
    # Create a hash of parameters
    params = Hash.new
    params[:name] = name
    params[:home_phone] = home_phone if home_phone
    params[:office_phone] = office_phone if office_phone
    
    # Store params in parsable hash
    options = {:query => {:card => params}}
    
    # Send post request with options
    self.class.get("/cards/store.xml", options)
  end
  
  # Seed
  # Sends a post request to cards/new/seed.xml with user-provided integer
  # Server-side: generates and saves 
  def seed number
    options = {:query => {:number => number}}
    self.class.post("/cards/new/seed.xml", options)
  end
  
  # Index
  # Sends a get request to cards/index
  def index
    self.class.get("/cards/index.xml");
  end
  
  def show name
    options = {:query => {:name => name}}
    self.class.get("/cards/show.xml", options)
  end
end


cu = CardUtil.new

case ARGV[0]
when 'add'
  puts cu.add(ARGV[1], ARGV[2], ARGV[3])
when 'delete'
  
when 'view'
  if ARGV[1] == "*"
    puts cu.index
  else
    puts cu.show ARGV[1];
  end
when 'change'
  cu.change(ARGV[1], ARGV[2])
when 'search'
  
when 'seed'
  cu.seed(ARGV[1])
else
  puts "Invalid method name"
end