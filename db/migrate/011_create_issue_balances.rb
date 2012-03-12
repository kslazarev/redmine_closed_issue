class CreateIssueBalances < ActiveRecord::Migration
  def self.up
    create_table :issue_balances do |t|
      t.integer :issue_id
      t.integer :volume
      t.float :price
    end
  end

  def self.down
    drop_table :issue_balances
  end
end
