class Task < ActiveRecord::Base

  validates_presence_of :name, :priority
  validates_numericality_of :priority

  validate :priority_must_be_within_range

protected

  def priority_must_be_within_range
    errors.add(:priority, 'must be between 1 and 4 inclusive') if priority > 4 or priority < 1
  end

end
