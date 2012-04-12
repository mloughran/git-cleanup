class GitCleanup
  module Helper
    def self.boolean(question, &block)
      Formatador.display_line ""
      Formatador.display("[bold][blue][QUESTION][/] #{question} (y/n)[/] ")
      answer = STDIN.gets.chomp
      if answer == 'y'
        yield
      elsif answer == 'n'
        return false
      else
        boolean(question, &block)
      end
    end
    
    def self.info(info)
      Formatador.display_line "[bold][yellow][INFO][/] #{info}[/]"
    end
  end
end