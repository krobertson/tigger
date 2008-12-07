class Entity
  attr_accessor :name, :path, :file, :size, :revision, :branch, :repository

  def initialize(repository, branch, path)
    @repository = repository
    @path = path
    @branch = branch.to_s
  end

  def file?
    @file
  end
  
  def dir?
    !@file
  end

  def contents
    return @contents if @contents
    return nil unless file?
    @contents = (@repository.backend.tree(@revision)/path).data
  end

  def diff(old_revision)
    return @diff if @diff
    return nil unless file?
    @diff = Grit::Commit.diff(@repository.backend, @revision, old_revision).collect { |d| d.diff if d.a_path == @path || d.b_path == @path } * "\n"
  end

  def convert(blob, path = nil)
    # convert a blob into an entity
    @name = blob.name
    @path = path == '' ? blob.name : path / blob.name if path
    @file = blob.is_a?(Grit::Blob)
    @size = blob.size if file?
    @revision = @repository.backend.log(@branch, @path, :max_count => 1).first.id
  end

  def <=>(other)
    if (dir? && other.dir?) || (!dir? && !other.dir?)
      name <=> other.name
    elsif dir?
      -1
    else
      1
    end
  end

  def self.get(repository, revision, path)
    # get the class and the blob
    blob = tree(repository, revision, path)

    # convert it to an entity
    entity = Entity.new(repository, revision, path)
    entity.convert(blob)
    entity
  end

  def self.get_children(repository, revision, path)
    tree(repository, revision, path).contents.collect do |blob|
      # if it isn't cached, process it
      entity = Entity.new(repository, revision, path)
      entity.convert(blob, path)
      entity
    end.sort
  end

  protected
  
  def self.tree(repository, revision, path)
    t = repository.backend.tree(revision)
    t = t / path unless path == ''
    t
  end
end