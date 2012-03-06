module Patches
  module UserPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development

        has_many :issues, :class_name => 'Issue', :foreign_key => 'author_id'
      end
    end

    module ClassMethods
    end

    module InstanceMethods
    end
  end
end
