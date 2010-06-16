require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "invalid with empty fields" do 
    task = Task.new 
    assert !task.valid?
    assert task.errors.invalid?(:name)
    assert task.errors.invalid?(:priority)
  end
  
  test "priority is numeric" do
    task = Task.new(:name => "My Task", :priority => "a string")
    assert !task.valid?
  end
  
  test "priority in range" do
    task = Task.new(:name => "My Task")
    
    task.priority = 0
    assert !task.valid?
    assert_equal "must be between 1 and 4 inclusive", task.errors.on(:priority)
    
    task.priority = 5
    assert !task.valid?
    assert_equal "must be between 1 and 4 inclusive", task.errors.on(:priority)
    
    task.priority = 2
    assert task.valid?
  end

end
