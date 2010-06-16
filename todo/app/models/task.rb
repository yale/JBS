class Task < ActiveRecord::Base
  
  belongs_to :project

  validates_presence_of :name, :priority
  validates_numericality_of :priority

  validate :priority_must_be_within_range

protected

  def priority_must_be_within_range
    errors.add(:priority, 'must be between 1 and 4 inclusive') if priority.nil? || (priority > 4 || priority < 1)
  end

end
