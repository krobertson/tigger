class Commit
  attr_accessor :message, :changed_at, :committed_at, :revision, :repository
  attr_accessor :author, :author_email, :committer, :committer_email

  def get_changes
    # get the backend commit
    c = project.backend.commit(revision)

    # loop over the changes
    c.diffs.collect do |diff|
      type = if diff.new_file
        :add
      elsif diff.deleted_file
        :remove
      elsif diff.a_path != diff.b_path
        :rename
      else
        :modify
      end
      [type, diff.a_path]
    end.sort
  end

  def <=>(other)
    other.changed_at <=> changed_at
  end

  def ==(other)
    revision == other.revision
  end

  def self.get_commits(repository, revision, path, page, size)
    repository.backend.log(revision, path, :max_count => size, :skip => (page-1) * size).collect do |c|
      convert(c)
    end
  end

  def self.get(repository, revision)
    c = repository.backend.commit(revision)
    return nil unless c
    convert(c)
  end

  def self.convert(commit)
    # Create the commit record
    c = Commit.new
    c.revision = commit.id
    c.author = commit.author.name
    c.author_email = commit.author.email
    c.committer = commit.committer.name
    c.committer_email = commit.committer.email
    c.changed_at = commit.authored_date
    c.committed_at = commit.committed_date
    c.message = commit.message
    c
  end

  def self.get_commit_count(repository, revision, path)
    # get commits and collect revisions
    repository.backend.log(revision, path).size
  end
end