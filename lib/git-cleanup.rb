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
    begin
      repo = Grit::Repo.new(Dir.pwd)
    rescue Grit::InvalidGitRepositoryError
      Formatador.display_line(%Q{[bold][red] Could not find git repository in "#{Dir.pwd}".[/]})
      exit
    end

    master_branch_name = options[:master_branch] || 'master'
    
    master = repo.heads.find { |h| h.name == master_branch_name }

    unless master
      Formatador.display_line(%Q{[bold][red] Could not find branch "#{master_branch_name}". Try using "-m BRANCH" to specify the master branch.[/]})
      exit
    end

    self.prune(repo)

    local_branches = repo.branches.map { |b| b.name }

    remote_branches = Branch.remote(repo).select { |b| b.commit.lazy_source }

    remote_branches.sort.reverse.each_with_index do |branch, index|
      next if branch.name == master_branch_name
      next if options[:only_filter] and !branch.name.match(options[:only_filter])

      msg = "Branch #{branch.to_s} (#{index+1}/#{remote_branches.size})"
      Formatador.display_line

      Formatador.display_line("[bold][green]#{msg}[/]")
      Formatador.display_line "[bold][green]" + '-' * msg.size + "[/]"

      # Diff of commit in branch which is not in master
      begin
        diff = branch.diff(master)
      rescue Grit::Git::GitTimeout => e
        Formatador.display_line("[bold][red] There was an error generating the diff.[/]")
        Formatador.display_line("[red]Message: #{e.message}")
        Formatador.display_line("Skipped")
        next
      end

      if diff.empty?
        Formatador.display_line "[bold]Branch merged.[/] Last commit on branch:"
        last_commit = branch.commit
        if last_commit
          Formatador.indent {
            Formatador.display_line "Author: #{last_commit.author}"
            Formatador.display_line "Date:   #{last_commit.committed_date}"
            Formatador.display_line "SHA:    #{last_commit.sha}"
            Formatador.display_line "#{last_commit.message}"
          }
        end

        Helper.boolean '[bold]Branch merged.[/] Do you want the branch deleted?' do
          branch.delete(local_branches)
        end
      else
        if options[:skip_unmerged]
          Helper.info "[bold]Branch not merged.[/] Skipped"
          next
        end

        commits = branch.commits(master)

        Formatador.display_line "[bold]Branch not merged.[/] Commits on branch:"

        Formatador.indent {
          Formatador.display_lines commits.split("\n")
        }

        Helper.boolean "[bold]Branch not merged.[/] Do you want to see a diff?" do
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
