module ClosedDateIssue
  class Hooks < Redmine::Hook::ViewListener
    def controller_issues_new_before_save context
      issue = context[:issue]

      if issue
        issue.customer_task_id = issue.author_id.issues.count + 1
        issue.closed_date = issue.status.is_closed? ? Time.now : nil
        issue.complete_date = complete? ? Time.now : nil
      end
    end

    def controller_issues_edit_before_save context
      issue = context[:issue]

      if issue
        saved_issue = Issue.find(issue.id)

        unless issue.same_status?(saved_issue)
          issue.closed_date = issue.status.is_closed? ? Time.now : nil
        end

        unless issue.same_done_ratio?(saved_issue)
          issue.complete_date = issue.complete? ? Time.now : nil
        end
      end
    end

    alias_method :controller_issues_bulk_edit_before_save, :controller_issues_edit_before_save
  end
end
