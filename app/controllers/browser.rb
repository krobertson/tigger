class Browser < Application
  before :ensure_current_repository
  before :ensure_current_revision, :with => [:repo_head]
  before :ensure_current_path

  def index
    current_entity.file? ? file : dir
  end

  def dir
    @entities = Entity.get_children(current_repository, current_revision, current_path)
    @latest_commit = @entities.collect { |e| e.commit }.sort.first
    render :dir
  end

  def file
    render :file
  end

  def download
    return redirect(url(:repo_path)) unless current_entity.file?
    send_data(current_entity.contents, :filename => current_entity.name)
  end
end