class GitCleanup
  module Helper
    def self.boolean(question, &block)
      Formatador.display_line ""
      Formatador.display("#{question} (y/n)[/] ")
      answer = STDIN.gets.chomp
      if answer == 'y'
        yield
      elsif answer == 'n'
        return false
      else
        boolean(question, &block)
      end
    end
  end
end