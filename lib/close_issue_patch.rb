module ClosedDateIssue
  class Hooks < Redmine::Hook::ViewListener
    def controller_issues_new_before_save context
      params = context[:params]
      issue = context[:issue]

      if issue
        issue.closed_date = issue.status.is_closed? ? Time.now : nil
        issue.complete_date = issue.complete? ? Time.now : nil

        issue.translation_language_id = params[:issue][:translation_language_id]
        issue.source_language_id = params[:issue][:source_language_id]
      end
    end

    def controller_issues_new_after_save context
      params = context[:params]
      issue = context[:issue]

      if issue
        params[:attachments].each do |key, value|
          attachment = issue.attachments[key.to_i - 1]
          if params[:calculation].try(:[], key).present?
            add_repeat_calculation(attachment, value)
          else
            add_simple_calculation(attachment, value)
          end
          add_layout_calculation(attachment, value)
          attachment.price = attachment.translation.price + attachment.layout.price
          attachment.save
        end
      end
    end

    def controller_issues_edit_before_save context
      params = context[:params]
      issue = context[:issue]

      if issue
        saved_issue = Issue.find(issue.id)

        unless issue.same_status?(saved_issue)
          issue.closed_date = issue.status.is_closed? ? Time.now : nil
        end

        unless issue.same_done_ratio?(saved_issue)
          issue.complete_date = issue.complete? ? Time.now : nil
        end

        unless issue.same_translation_language?(saved_issue)
          issue.translation_language_id = params[:issue][:translation_language_id]
        end

        unless issue.same_source_language?(saved_issue)
          issue.source_language_id = params[:issue][:source_language_id]
        end
      end
    end

    alias_method :controller_issues_bulk_edit_before_save, :controller_issues_edit_before_save

    private

    def add_simple_calculation attachment, params
      attachment.build_translation(
        :volume => params['volume'].to_f,
        :rate => params['rate'].to_f,
        :price => params['volume'].to_f * params['rate'].to_f
      )
    end

    def add_layout_calculation attachment, params
      layout_volume = params['layout']['volume'].to_f
      layout_rate = params['layout']['rate'].to_f

      attachment.build_layout(
        :volume => layout_volume,
        :rate => layout_rate,
        :price => layout_volume * layout_rate
      )
    end

    def add_repeat_calculation attachment, params
      general_volume = 0
      general_rate = 0
      general_rate_count = 4

      translation = attachment.build_translation

      4.times do |index|
        volume = params["#{index + 1}"]['volume'].to_f
        rate = params["#{index + 1}"]['rate'].to_f
        general_volume += volume.to_f
        general_rate += rate.to_f
        general_rate_count = general_rate_count - 1 if params["#{index + 1}"]['rate'] == ''

        translation.repeats.build(
          :percent_type => index,
          :volume => volume,
          :rate => rate,
          :price => volume.to_f * rate.to_f
        )
      end

      translation.volume = general_volume
      translation.rate = general_rate/general_rate_count
      translation.price = translation.volume * translation.rate
    end
  end
end
