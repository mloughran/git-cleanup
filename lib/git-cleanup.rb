require 'grit'
require 'tempfile'

# Grit.debug = true

class GitCleanup
  def self.run
    repo = Grit::Repo.new(Dir.pwd)
    
    master = repo.heads.find { |h| h.name == 'master' }

    local_branches = repo.branches.map { |b| b.name }

    remote_branches = Branch.remote(repo).select { |b| b.commit.lazy_source }

    remote_branches.sort.each_with_index do |branch, index|
      # Diff of commit in branch which is not in master
      diff = branch.diff(master)

      msg = "Branch #{branch.to_s} (#{index+1}/#{remote_branches.size})"
      puts
      puts msg
      puts '-' * msg.size

      if diff.empty?
        last_commit = branch.commit
        if last_commit
          puts "Last commit:"
          puts "Author: #{last_commit.author}"
          puts "Date:   #{last_commit.committed_date}"
          puts "SHA:    #{last_commit.sha}"
          puts "#{last_commit.message}"
          puts
        end

        Helper.boolean 'All commits merged. Do you want the branch deleted?' do
          branch.delete(local_branches)
        end
      else
        Helper.boolean "Branch not merged. Do you want to see a diff?" do
          Tempfile.open('diff') do |tempfile|
            tempfile << diff
            tempfile.flush
            
            if ENV["GIT_EDITOR"]
              `#{ENV["GIT_EDITOR"]} #{tempfile.path}`
            else
              puts diff
            end
          end
          Helper.boolean "Do you want the branch deleted?" do
            branch.delete(local_branches)
          end
        end
      end
    end
  end
end

require 'git-cleanup/branch'
require 'git-cleanup/helper'
