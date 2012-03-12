ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'issues_statistics', :action => 'index' do |routes|
    routes.connect '/projects/:project_id/statistics'
  end

  map.with_options :controller => 'issues_parent', :action => 'index' do |routes|
    routes.connect '/projects/:project_id/parent_statistics'
  end

end