require 'redmine'
require 'dispatcher'
require 'patches/patches'
#require 'query_patch_closed_date'
require 'close_issue_patch'
require 'redmine/default_data/language_loader'


Dispatcher.to_prepare :redmine_issue_active_dependency do
  require_dependency 'issue'

  unless Issue.included_modules.include? Patches::IssuePatch
    Issue.send(:include, Patches::IssuePatch)
  end

  unless User.included_modules.include? Patches::UserPatch
    User.send(:include, Patches::UserPatch)
  end

  unless Attachment.included_modules.include? Patches::AttachmentPatch
    Attachment.send(:include, Patches::AttachmentPatch)
  end

  unless IssueMovesController.included_modules.include? Patches::IssueMovesControllerPatch
    IssueMovesController.send(:include, Patches::IssueMovesControllerPatch)
  end
end

Redmine::Plugin.register :redmine_redmine_close_issue do
  name 'Redmine Closed Date plugin'
  author 'Matheus Ashton Silva, Kirill Lazarev'
  description 'A plugin that save the date when the issue is closed (completed), and shows it on issue/show view'
  version '0.0.4.5'
  url 'http://github.com/kslazarev/redmine_closed_issue'
  author_url 'http://matheusashton.net'

  #permission :view_translation_statistics, {}
  permission :view_translation_statistics, {
      :issues_statistics => [:index],
      :issues_parent => [:index],
      :issues => [:destroy_description, :destroy_journals]
  }

  menu :project_menu, :statistics, {:controller => 'issues_statistics', :action => 'index'}, :caption => :statistics,
    :after => :issues, :param => :project_id

  menu :project_menu, :issues_parent, {:controller => 'issues_parent', :action => 'index'}, :caption => :issues_parent,
    :after => :issues, :param => :project_id
end

Dispatcher.to_prepare do
  Query.send(:include, Patches::IssueQueryPatch)
end

