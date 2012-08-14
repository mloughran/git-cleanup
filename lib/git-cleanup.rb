require 'grit'
require 'tempfile'
require 'formatador'
# Grit.debug = true

# No default indent
class Formatador
  def initialize
    @indent = 0
  end
end

class GitCleanup
  def self.run(options = {})
    repo = Grit::Repo.new(Dir.pwd)
    
    master = repo.heads.find { |h| h.name == 'master' }

    self.prune(repo)

    local_branches = repo.branches.map { |b| b.name }

    remote_branches = Branch.remote(repo).select { |b| b.commit.lazy_source }

    remote_branches.sort.reverse.each_with_index do |branch, index|
      next if branch.name == 'master'
      next if options[:only_filter] and !branch.name.match(options[:only_filter])

      # Diff of commit in branch which is not in master
      diff = branch.diff(master)
      commits = branch.commits(master)

      msg = "Branch #{branch.to_s} (#{index+1}/#{remote_branches.size})"
      Formatador.display_line

      Formatador.display_line("[bold][green]#{msg}[/]")
      Formatador.display_line "[bold][green]" + '-' * msg.size + "[/]"

      if diff.empty?
        Formatador.display_line "Branch merged. Last commit on branch:"
        last_commit = branch.commit
        if last_commit
          Formatador.indent {
            Formatador.display_line "Author: #{last_commit.author}"
            Formatador.display_line "Date:   #{last_commit.committed_date}"
            Formatador.display_line "SHA:    #{last_commit.sha}"
            Formatador.display_line "#{last_commit.message}"
          }
        end

        Helper.boolean 'Do you want the branch deleted?' do
          branch.delete(local_branches)
        end
      else
        if options[:skip_unmerged]
          Helper.info "Branch not merged. Skipped"
          next
        end

        Formatador.display_line "Branch not merged. Commits on branch:"

        Formatador.indent {
          Formatador.display_lines commits.split("\n")
        }

        Helper.boolean "Do you want to see a diff?" do
          Tempfile.open('diff') do |tempfile|
            tempfile << diff
            tempfile.flush
            
            if ENV["GIT_EDITOR"]
              `#{ENV["GIT_EDITOR"]} #{tempfile.path}`
            else
              Formatador.display_line diff
            end
          end
          Helper.boolean "Do you want the branch deleted?" do
            branch.delete(local_branches)
          end
        end
      end
    end
  end

  # Prunes branches that have already been removed on origin
  def self.prune(repo)
    list = repo.git.native(:remote, {}, 'prune', '-n', "origin")
    if !list.empty?
      Helper.boolean "Planning to prune the following. Ok?\n#{list}" do
        repo.git.native(:remote, {}, 'prune', "origin")
      end
    end
  end
end

require 'git-cleanup/branch'
require 'git-cleanup/helper'
require 'git-cleanup/version'
