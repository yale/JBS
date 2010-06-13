class AddTodayToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :today, :boolean
  end

  def self.down
    remove_column :tasks, :today
  end
end
