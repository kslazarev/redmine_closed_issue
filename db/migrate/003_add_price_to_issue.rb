class AddPriceToIssue < ActiveRecord::Migration
  def self.up
    change_table :issues do |t|
      t.float :price
    end
  end

  def self.down
    change_table :issues do |t|
      t.remove :price
    end
  end
end
