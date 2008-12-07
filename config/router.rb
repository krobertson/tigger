REPO_PATH = /[A-Za-z0-9\/\._\-]*/

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  # Project routes
  match('/:repo').to(:controller => 'browser', :action => 'index').name(:repo)
  match('/:repo/diff/:old_revision/:revision/:repo_path', :repo_path => REPO_PATH).to(:controller => 'browser', :action => 'diff').name(:diff)
  match('/:repo/source/:revision').to(:controller => 'browser', :action => 'index').name(:repo_head)
  match('/:repo/source/:revision/:repo_path', :repo_path => REPO_PATH).to(:controller => 'browser', :action => 'index').name(:repo_path)
  match('/:repo/download/:revision/:repo_path', :repo_path => REPO_PATH).to(:controller => 'browser', :action => 'download').name(:download)

  # Commit routes
  match('/:repo/commits').to(:controller => 'commits', :action => 'index').name(:commits)
  match('/:repo/commit/:revision').to(:controller => 'commits', :action => 'show').name(:commit)
  match('/:repo/commits/:revision').to(:controller => 'commits', :action => 'index').name(:commits_head)
  match('/:repo/commits/:revision/:repo_path', :repo_path => REPO_PATH).to(:controller => 'commits', :action => 'index').name(:commits_path)
  
  # Homepage
  match('/').to(:controller => 'dashboard', :action => 'index').name(:dashboard)
end