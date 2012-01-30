require 'redmine'
require 'dispatcher'
require 'query_patch_closed_date'
require 'close_issue_patch'


Redmine::Plugin.register :redmine_redmine_close_issue do
  name 'Redmine Closed Date plugin'
  author 'Matheus Ashton Silva, Kirill Lazarev'
  description 'A plugin that save the date when the issue is closed (completed), and shows it on issue/show view'
  version '0.0.2'
  url 'http://github.com/kslazarev/redmine_closed_issue'
  author_url 'http://matheusashton.net'
end

Dispatcher.to_prepare do
  Query.send(:include, IssueQueryPatch)
end