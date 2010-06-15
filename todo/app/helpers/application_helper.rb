# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def until_due_date task
    due = distance_of_time_in_words(task.due_date, Time.now, false, :only => 'days')
    output = (due.empty?) ? "today" : "in #{due}"
  end
end
