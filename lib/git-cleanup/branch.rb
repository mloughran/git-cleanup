class GitCleanup
  class Branch
    include Comparable
  
    def self.remote(repo)
      repo.remotes.map { |r| new(repo, r) }
    end
  
    attr_reader :remote, :name, :ref
  
    def initialize(repo, ref)
      @repo = repo
      @ref = ref
      @remote, @name = ref.name.split('/')
    end
  
    def to_s
      "#{remote}/#{name}"
    end
  
    def diff(ref)
      @repo.git.native(:diff, {}, "#{ref.commit.sha}...#{@ref.commit.sha}")
    end

    def commits(ref)
      @repo.git.native(:log, {}, "#{ref.commit.sha}..#{@ref.commit.sha}")
    end
  
    def commit
      @ref.commit
    end

    def delete(local_branches = nil)
      puts "Deleting..."
      @repo.git.native(:push, {}, @remote, ":#{@name}")
      puts "Done"

      if local_branches && local_branches.include?(name)
        Helper.boolean "There is also a local branch called #{name}. Would you like to delete that too?" do
          puts "Deleting..."
          @repo.git.native(:branch, {}, '-d', name)
          puts "Done"
        end
      end
    end
  
    def <=>(other)
      commit.committed_date <=> other.commit.committed_date
    end
  end
end
