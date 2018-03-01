require "rail_grinder/project"
require "rail_grinder/version"

# require 'awesome_print'
# TODO: Don't load this as a matter of course
# require 'byebug'
require 'English'
require 'readline'
# require 'rugged'

module RailGrinder
  class Runner
    def run
      @project = RailGrinder::Project.get

      # Drop the user in a prompt and process commands as they are entered
      update_prompt
      while line = Readline.readline(@prompt, true)
        args = line.split
        command = args.shift

        case command
        when 'add'
          # rg> add git@gitlab.com:lycoperdon/foo.git
          @project.add_repo(args.shift)
        when 'target'
          # rg> target rails 4.2.7
          (target_gem, target_version) = *args
          @project.set_target(target_gem, target_version)
          update_prompt
        when 'status'
          @project.show_status
        when 'help'
          show_help
        when /exit|quit/
          @project.save_state
          puts "Goodbye..."
          break
        else
          puts "I'm sorry, I don't know about that command"
          show_help
        end
      end

      # TODO:
      # Clean out after testing...
      # `rm -rf repos/{*,.*}
    end

    private

    def update_prompt
      (gem, version) = @project.get_target
      gem ||= ''
      version ||= ''
      @prompt = "rg #{gem}:#{version}> "
    end

    def show_help
      puts "TODO: Actually put the help here"
    end
  end
end
