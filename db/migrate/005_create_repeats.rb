class CreateRepeats < ActiveRecord::Migration
  def self.up
    create_table :repeats do |t|
      t.integer :translation_id
      t.float :volume
      t.integer :percent_type
      t.float :rate
      t.float :price
    end
  end

  def self.down
    drop_table :repeats
  end
end
