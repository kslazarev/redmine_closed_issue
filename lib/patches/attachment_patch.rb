module Patches
  module AttachmentPatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development

        has_one :translation
        has_one :layout

        accepts_nested_attributes_for :translation
        accepts_nested_attributes_for :layout
      end
    end

    module ClassMethods
    end

    module InstanceMethods
    end
  end
end
