class IssuesAdditionalController < ApplicationController
  unloadable

  def destroy_description
    issue = Issue.find(params[:id])
    issue.description = ""
    issue.save
    redirect_to :controller => :issues, :action => :show, :id => issue.id
  end

  def destroy_history
    issue = Issue.find(params[:id])
    issue.journals = []
    issue.save
    redirect_to :controller => :issues, :action => :show, :id => issue.id
  end
end