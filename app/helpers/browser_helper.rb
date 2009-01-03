module Merb
  module BrowserHelper
    def breadcrumb
      current_path.split('/').join(' / ')
    end

    def collect_branch_options
      options = {}
      options[:collection] = current_repository.branches.collect { |b| [url(:repo_path, :revision => b), b]}
      unless current_entity.branch == current_repository.default_branch
        options[:collection] << [url(:repo_path, :revision => current_entity.branch), current_entity.branch.truncate(7, '')]
        options[:collection] = options[:collection].uniq
      end
      options[:selected] = url(:repo_path, :revision => current_entity.branch)
      options
    end
  end
end # Merb