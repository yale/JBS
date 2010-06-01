=begin
  Name:   Animal Game
  Description: An animal guessing game. The user is asked to guess
  an animal, and the program attempts to guess it based on a
  "yes/no" tree of questions. The tree grows over time based on
  user input, thus making the program more likely to guess a given
  animal.
  Author: Yale Spector
  Date:   5/28/2010
=end

# Stores all of the questions in a Game object
#
class Game
  # Make the first question readable by the program
  attr_reader :first_question
  
  def initialize(question, yes_animal, no_animal)
    @first_question = Question.new question
    @first_question.yes = Question.new yes_animal
    @first_question.no = Question.new no_animal
    @database = [@first_question, @first_question.yes, @first_question.no]
  end
  
  # This method adds a new question and answer to the database
  # based on user feedback
  #
  def refine(incorrect_guess, animal, new_question)
    old_animal = incorrect_guess.data
    incorrect_guess.data = new_question
    incorrect_guess.yes = Question.new animal
    incorrect_guess.no = Question.new old_animal
    
    # Add the new questions to the database
    @database << incorrect_guess.yes
    @database << incorrect_guess.no
  end
  
  def begin
    puts "Welcome to Animal Game!\n"
    puts "Think of an animal. I will try to guess it.\n\n"
    ask @first_question
  end
end

class Question
  attr_accessor :data
  attr_accessor :yes
  attr_accessor :no
  
  def initialize(data)
    @data = data
    @yes = nil
    @no = nil
  end
  
  # This method checks if the current question is a terminal question
  # i.e. that it is should be asked in the form "Are you thinking of: [...]?"
  #
  def animal?
    not (@yes or @no)
  end
  
  # This method returns the text of the question
  #
  def to_s
    if animal?
      "Are you thinking of: #{@data}?"
    else
      @data
    end
  end
  
end

# Asks a question to the user and receives a y/n input
#
def ask question
  
  # Ask the question
  puts question.to_s + " (y/n): "
  
  # If the question is guessing an animal...
  if question.animal?
    finish question
  else
    
    # Store the user's y/n input
    answer = gets
    
    # If the answer is yes, ask the "yes" branch of that question
    if answer =~ /y/
      ask question.yes
      
    # If no...
    elsif answer =~ /n/
      ask question.no
      
    # Otherwise, the user typed in something other than y/n
    else
      "Invalid input! Please try again.\n"
      ask question
    end
  end
end

# Present a guess to the user
#
def finish question
  # Store the user's y/n input
  answer = gets
  
  # If the answer is yes, then the program has guess correctly
  if answer =~ /y/
    puts "I'm so smart. Thanks for playing!\n"
  
  # Otherwise, collect data from user to improve guessing tree
  elsif answer =~ /n/
    puts "Oh no... could you tell me what animal you were thinking of?"
    animal = gets.chomp
    puts "And what question would distinguish your animal from what I guessed?"
    new_question = gets.chomp
    puts "Ok. I will remember this for next time!"
    
    # Add new question and answer to the database
    $game.refine(question, animal, new_question)
    
    # Save the database
    File.open("game.dump", "wb") { |file| Marshal.dump($game, file) }
  end
  
  # Ask the user if he/she would like to play again
  puts "Play again? (y/n)"
  answer = gets
  if answer =~ /y/
    $game.begin
  else
    Process.exit
  end
end  

# If a database exists, load it; otherwise, create a new Game object
if File.exists?("game.dump")
  $game = File.open("game.dump", "rb") { |file| Marshal.load(file) }
  puts "[Loaded saved database]"
else
  $game = Game.new("Does your animal have wings?", "pidgeon", "frog")
  puts "[New database created]"
end

# Begin the game!!
$game.begin