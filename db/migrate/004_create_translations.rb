class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.integer :attachment_id
      t.integer :volume
      t.float :rate
      t.float :price
    end
  end

  def self.down
    drop_table :translations
  end
end
