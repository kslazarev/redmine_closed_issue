class CreateLayouts < ActiveRecord::Migration
  def self.up
    create_table :layouts do |t|
      t.integer :volume
      t.float :rate
      t.float :price
    end
  end

  def self.down
    drop_table :layouts
  end
end
