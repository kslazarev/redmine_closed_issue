class AddTranslationLanguageToIssue < ActiveRecord::Migration
  def self.up
    change_table :issues do |t|
      t.integer :translation_language_id
    end
  end

  def self.down
    change_table :issues do |t|
      t.remove :translation_language_id
    end
  end
end
