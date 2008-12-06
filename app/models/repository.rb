class Repository
  attr_accessor :path, :description

  def self.all
    Dir.glob(Merb.root / 'repos' / '*').collect do |dir|
      repo = Repository.new
      repo.path = File.basename(dir).chomp('.git')
      repo.description = File.read(dir / 'description').chomp if File.exist?(dir / 'description')
      repo.description = repo.path.capitalize if repo.description.nil? || repo.description == '' || repo.description == 'Unnamed repository; edit this file to name it for gitweb.'
      repo
    end
  end
end