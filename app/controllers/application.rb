class Application < Merb::Controller
  def ensure_current_repository
    raise NotFound unless current_repository
  end

  def ensure_current_revision(route)
    if params[:revision].nil?
      redirect url(route, :revision => 'master')
      throw :halt
    end
  end

  def ensure_current_path
    raise NotFound if !current_entity && current_path != ''
  end

  def current_repository
    return nil if params[:repo].blank?
    @current_repository ||= Repository.get(params[:repo])
  end

  def current_revision
    @current_revision ||= params[:revision].downcase
  end

  def current_path
    params[:repo_path] || ''
  end

  def current_entity
    @current_entity ||= Entity.get(current_repository, current_revision, current_path)
  end
end