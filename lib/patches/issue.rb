module Patches
  module Issue
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      #has_many :issues, :foreign_key => 'author_id'

      COMPLETE_PERCENT = 100

      def complete?
        COMPLETE_PERCENT == context[:issue].done_ratio
      end

      def same_status? issue
        status == issue.status
      end

      def same_done_ratio? issue
        done_ratio == issue.done_ratio
      end
    end
  end
end
