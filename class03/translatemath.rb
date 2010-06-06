=begin
  Name: Postfix to Infix Translator
  Author: Yale Spector
  Description: This program converts mathematical expressions from postfix notation to infix notation
  Usage: "ruby translatemath.rb 'expr'"
=end

# Create an array containing each symbol in the expression
postfix = ARGV[0].split

# Initalize an empty stack array
stack = Array.new

# Loop through the elements in the postfix array
postfix.each do |element|
  
  # If the element is an operator...
  if element =~ /\+|\-|\*|\//
    
    # ... then the previous two elements on the stack are operators.
    operand2, operand1 = stack.pop, stack.pop
    
    # If the operator is either * or /, we should apply parenthesis
    # to any compound operands
    if element =~ /\*|\//
      operand1 = "(#{operand1})" if operand1 =~ /\+|\-/
      operand2 = "(#{operand2})" if operand2 =~ /\+|\-/
    end
    
    # Push the new compound expression onto the stack
    stack << "#{operand1} #{element} #{operand2}"
  
  # Otherwise,
  else
    
    # the element is a numeral. Push it onto the stack
    stack << element
  end
end

# Return the resultant stack element
puts stack.pop