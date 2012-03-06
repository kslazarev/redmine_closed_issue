class Translation < ActiveRecord::Base
  has_many :repeats

  accepts_nested_attributes_for :repeats
end