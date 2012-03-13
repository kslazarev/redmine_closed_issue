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

        alias_method_chain :validate_issue, :cross_project
        alias_method_chain :move_to_project_without_transaction, :cross_project
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

      def validate_issue_with_cross_project
        if self.due_date.nil? && @attributes['due_date'] && !@attributes['due_date'].empty?
          errors.add :due_date, :not_a_date
        end

        if self.due_date and self.start_date and self.due_date < self.start_date
          errors.add :due_date, :greater_than_start_date
        end

        if start_date && soonest_start && start_date < soonest_start
          errors.add :start_date, :invalid
        end

        if fixed_version
          if !assignable_versions.include?(fixed_version)
            errors.add :fixed_version_id, :inclusion
          elsif reopened? && fixed_version.closed?
            errors.add :base, I18n.t(:error_can_not_reopen_issue_on_closed_version)
          end
        end

        # Checks that the issue can not be added/moved to a disabled tracker
        if project && (tracker_id_changed? || project_id_changed?)
          unless project.trackers.include?(tracker)
            errors.add :tracker_id, :inclusion
          end
        end

        # Checks parent issue assignment
        if @parent_issue
          if !new_record?
            # moving an existing issue
            if @parent_issue.root_id != root_id
              # we can always move to another tree
            elsif move_possible?(@parent_issue)
              # move accepted inside tree
            else
              errors.add :parent_issue_id, :not_a_valid_parent
            end
          end
        end
      end
    end

    def move_to_project_without_transaction_with_cross_project(new_project, new_tracker = nil, options = {})
      options ||= {}
      issue = options[:copy] ? self.class.new.copy_from(self) : self

      if new_project && issue.project_id != new_project.id
        # delete issue relations
        unless Setting.cross_project_issue_relations?
          issue.relations_from.clear
          issue.relations_to.clear
        end
        # issue is moved to another project
        # reassign to the category with same name if any
        new_category = issue.category.nil? ? nil : new_project.issue_categories.find_by_name(issue.category.name)
        issue.category = new_category
        # Keep the fixed_version if it's still valid in the new_project
        unless new_project.shared_versions.include?(issue.fixed_version)
          issue.fixed_version = nil
        end
        issue.project = new_project
      end
      if new_tracker
        issue.tracker = new_tracker
        issue.reset_custom_values!
      end
      if options[:copy]
        issue.author = User.current
        issue.custom_field_values = self.custom_field_values.inject({}) {|h,v| h[v.custom_field_id] = v.value; h}
        issue.status = if options[:attributes] && options[:attributes][:status_id]
                         IssueStatus.find_by_id(options[:attributes][:status_id])
                       else
                         self.status
                       end
      end
      # Allow bulk setting of attributes on the issue
      if options[:attributes]
        issue.attributes = options[:attributes]
      end
      if issue.save
        if options[:copy]
          if current_journal && current_journal.notes.present?
            issue.init_journal(current_journal.user, current_journal.notes)
            issue.current_journal.notify = false
            issue.save
          end
        else
          # Manually update project_id on related time entries
          TimeEntry.update_all("project_id = #{new_project.id}", {:issue_id => id})

          issue.children.each do |child|
            unless child.move_to_project_without_transaction(new_project)
              # Move failed and transaction was rollback'd
              return false
            end
          end
        end
      else
        return false
      end
      issue
    end
  end
end
