class Repository
  attr_accessor :path, :full_path, :description

  def branches
    @branches ||= backend.heads.collect { |h| h.name }
  end

  def backend
    @backend ||= Grit::Repo.new(@full_path)
  end

  def self.all
    Dir.glob(Merb.root / 'repos' / '*').collect do |dir|
      repo = Repository.new
      repo.full_path = dir
      repo.path = File.basename(dir).chomp('.git')
      repo.description = File.read(dir / 'description').chomp if File.exist?(dir / 'description')
      repo.description = repo.path.capitalize if repo.description.nil? || repo.description == '' || repo.description == 'Unnamed repository; edit this file to name it for gitweb.'
      repo
    end
  end

  def self.get(path)
    dir = Merb.root / 'repos' / path + '.git'

    repo = Repository.new
    repo.full_path = dir
    repo.path = path
    repo.description = File.read(dir / 'description').chomp if File.exist?(dir / 'description')
    repo.description = repo.path.capitalize if repo.description.nil? || repo.description == '' || repo.description == 'Unnamed repository; edit this file to name it for gitweb.'
    repo
  end
end