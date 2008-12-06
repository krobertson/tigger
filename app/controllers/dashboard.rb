class Dashboard < Application
  def index
    @repositories = Repository.all
    display @repositories
  end
end