class Browser < Application
  before :ensure_current_repository
  before :ensure_current_revision, :with => [:repo_head]
  before :ensure_current_path

  def index
    current_entity.file? ? file : dir
  end

  def dir
    @entities = Entity.get_children(current_repository, current_revision, current_path)
    render :dir
  end

  def file
  end
end