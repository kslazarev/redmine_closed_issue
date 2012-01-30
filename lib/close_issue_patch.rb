module ClosedDateIssue
  class Hooks < Redmine::Hook::ViewListener
    COMPLETE_PERCENT = 100

    def controller_issues_new_before_save(context)
      if context[:issue]
        context[:issue].closed_date = Time.now if context[:issue].status.is_closed?
        context[:issue].complete_date = Time.now if COMPLETE_PERCENT == context[:issue].done_ratio
      end
    end

    def controller_issues_edit_before_save(context)
      if context[:issue]
        current_issue = Issue.find(context[:issue].id)

        unless context[:issue].status == current_issue.status
          context[:issue].status.is_closed? ?
            context[:issue].closed_date = Time.now : context[:issue].closed_date = nil
        end

        unless context[:issue].done_ratio == current_issue.done_ratio
          COMPLETE_PERCENT == context[:issue].done_ratio ?
            context[:issue].complete_date = Time.now : context[:issue].complete_date = nil
        end
      end
    end

    alias_method :controller_issues_bulk_edit_before_save, :controller_issues_edit_before_save
  end
end
