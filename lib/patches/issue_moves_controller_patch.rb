module Patches
  module IssueMovesControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :create, :custom_helper
      end
    end

    module InstanceMethods
      def create_with_custom_helper
        prepare_for_issue_move

        if request.post?
          new_tracker = params[:new_tracker_id].blank? ? nil : @target_project.trackers.find_by_id(params[:new_tracker_id])
          unsaved_issue_ids = []
          moved_issues = []
          @issues.each do |issue|
            issue.reload
            issue.init_journal(User.current)
            issue.current_journal.notes = @notes if @notes.present?
            call_hook(:controller_issues_move_before_save, {:params => params, :issue => issue, :target_project => @target_project, :copy => !!@copy})
            if r = issue.move_to_project(@target_project, new_tracker, {:copy => @copy, :attributes => extract_changed_attributes_for_move(params)})
              r.attachments = issue.attachments.map do |attachment|
                result = attachment.clone
                result.translation = attachment.translation.clone
                result.translation.repeats = []
                attachment.translation.repeats.each do |repeat|
                  result.translation.repeats << repeat.clone
                end
                result.layout = attachment.layout.clone
                result
              end
              r.save
              moved_issues << r
            else
              unsaved_issue_ids << issue.id
            end


          end
          set_flash_from_bulk_issue_save(@issues, unsaved_issue_ids)

          if params[:follow]
            if @issues.size == 1 && moved_issues.size == 1
              redirect_to :controller => 'issues', :action => 'show', :id => moved_issues.first
            else
              redirect_to :controller => 'issues', :action => 'index', :project_id => (@target_project || @project)
            end
          else
            redirect_to :controller => 'issues', :action => 'index', :project_id => @project
          end
          return
        end
      end
    end
  end
end
