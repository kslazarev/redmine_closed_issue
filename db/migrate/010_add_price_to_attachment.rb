class AddPriceToAttachment < ActiveRecord::Migration
  def self.up
    change_table :attachments do |t|
      t.integer :price
    end
  end

  def self.down
    change_table :attachments do |t|
      t.remove :price
    end
  end
end
