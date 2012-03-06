class AddAttachmentIdToLayout < ActiveRecord::Migration
  def self.up
    change_table :layouts do |t|
      t.integer :attachment_id
    end
  end

  def self.down
    change_table :layouts do |t|
      t.remove :attachment_id
    end
  end
end
