class AddSourceLanguageToIssue < ActiveRecord::Migration
  def self.up
    change_table :issues do |t|
      t.integer :source_language_id
    end
  end

  def self.down
    change_table :issues do |t|
      t.remove :source_language_id
    end
  end
end
