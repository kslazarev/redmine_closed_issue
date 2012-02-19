require 'redmine'
require 'dispatcher'
require 'patches/patches'
#require 'query_patch_closed_date'
require 'close_issue_patch'


Dispatcher.to_prepare :redmine_issue_dependency do
  require_dependency 'issue'

  unless Issue.included_modules.include? Patches::Issue
    Issue.send(:include, Patches::Issue)
  end
end

Redmine::Plugin.register :redmine_redmine_close_issue do
  name 'Redmine Closed Date plugin'
  author 'Matheus Ashton Silva, Kirill Lazarev'
  description 'A plugin that save the date when the issue is closed (completed), and shows it on issue/show view'
  version '0.0.2'
  url 'http://github.com/kslazarev/redmine_closed_issue'
  author_url 'http://matheusashton.net'
end

Dispatcher.to_prepare do
  Query.send(:include, Patches::IssueQuery)
end