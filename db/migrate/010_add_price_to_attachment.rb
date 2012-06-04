class AddPriceToAttachment < ActiveRecord::Migration
  def self.up
    change_table :attachments do |t|
      t.float :price
    end
  end

  def self.down
    change_table :attachments do |t|
      t.remove :price
    end
  end
end
