class AddCompleteTimeToIssue < ActiveRecord::Migration
  def self.up
    change_table :issues do |t|
      t.datetime :complete_date
    end
  end

  def self.down
    change_table :issues do |t|
      t.remove :complete_date
    end

  end
end
