class AddVolumeToAttachment < ActiveRecord::Migration
  def self.up
    change_table :attachments do |t|
      t.integer :volume
    end
  end

  def self.down
    change_table :attachments do |t|
      t.remove :volume
    end
  end
end
