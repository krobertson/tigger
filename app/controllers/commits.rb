class Commits < Application
  before :ensure_current_repository
  before :ensure_current_revision, :with => [:commits_head], :only => [:index]
  before :ensure_current_path, :only => [:index]

  def index
    raise NotFound if current_entity.nil?

    page = params[:page] ? params[:page].to_i : 1
    @commits = Commit.get_commits(current_repository, current_revision, current_path, page, 10)

    render
  end

  def show(revision)
    @commit = Commit.get(current_repository, revision)
    raise NotFound if @commit.nil?
    render
  end
end