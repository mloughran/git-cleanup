class GitCleanup
  module Helper
    def self.boolean(question)
      puts "#{question} (y/n)"
      answer = STDIN.gets.chomp
      if answer == 'y'
        yield
      elsif answer == 'n'
        return false
      else
        boolean(question)
      end
    end
  end
end