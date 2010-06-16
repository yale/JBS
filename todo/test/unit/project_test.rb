require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "invalid with empty name" do 
    project = Project.new 
    assert !project.valid?
    assert project.errors.invalid?(:name)
  end
  
  test "project name is unique" do
    project = Project.new(:name => projects(:one).name)
    assert !project.save
    assert_equal "has already been taken", project.errors.on(:name)
  end
end
