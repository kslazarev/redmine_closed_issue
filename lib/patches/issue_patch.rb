module Patches
  module IssuePatch
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development

        belongs_to :source_language, :class_name => 'Language', :foreign_key => 'source_language_id'
        belongs_to :translation_language, :class_name => 'Language', :foreign_key => 'translation_language_id'
        has_one :balance, :class_name => 'IssueBalance'
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      COMPLETE_PERCENT = 100

      def complete?
        COMPLETE_PERCENT == done_ratio
      end

      def same_status? issue
        status == issue.status
      end

      def same_done_ratio? issue
        done_ratio == issue.done_ratio
      end

      def same_translation_language? issue
        translation_language == issue.translation_language
      end

      def same_source_language? issue
        source_language == issue.source_language
      end

      def same_parent? issue
        parent_id == issue.parent_id
      end

      def attachments_translation_volumes
        if attachments.any?
          attachments.map { |attachment| attachment.try(:translation).try(:volume) || 0.0 }.sum
        else
          0.0
        end
      end

      def attachments_translation_rates
        if attachments.any?
          attachments.map { |attachment| attachment.try(:translation).try(:rate) || 0.0 }.sum
        else
          0.0
        end
      end

      def attachments_translation_prices
        if attachments.any?
          attachments.map { |attachment| attachment.try(:translation).try(:price) || 0.0}.sum
        else
          0.0
        end
      end

      def attachments_layout_volumes
        if attachments.any?
          attachments.map { |attachment| attachment.try(:layout).try(:volume) || 0.0 }.sum
        else
          0.0
        end
      end

      def attachments_layout_rates
        if attachments.any?
          attachments.map { |attachment| attachment.try(:layout).try(:rate) || 0.0 }.sum
        else
          0.0
        end
      end

      def attachments_layout_prices
        if attachments.any?
          attachments.map { |attachment| attachment.try(:layout).try(:price) || 0.0}.sum
        else
          0.0
        end
      end

      def attachments_prices
        if attachments.any?
          attachments.map { |attachment| attachment.try(:price) || 0.0}.sum
        else
          0.0
        end
      end

      def attachments_volumes
        if attachments.any?
          attachments.map { |attachment| attachment.try(:volume) || 0.0}.sum
        else
          0.0
        end
      end

      def balance_volume
        balance.present? ? balance.volume : 0
      end

      def balance_price
        balance.present? ? balance.price : 0.0
      end

      def id_for_customer
        author.issues.try(:index, self) + 1
      end

      def author_id_for_customer
        author.id_for_customer
      end
    end
  end
end
