require "rail_grinder/project"
require "rail_grinder/version"

# require 'awesome_print'
# TODO: Don't load this as a matter of course
# require 'byebug'
require 'English'
require 'readline'
# require 'rugged'

module RailGrinder
  REPO_DIR = 'repos'
  STATE_FILE = '.rail_grinder'

  def RailGrinder.show_help
    puts "TODO: Actually put the help here"
  end

  def RailGrinder.run
    # If there is saved project state, load it.
    # Otherwise create a new project.
    project = if File.exist?(STATE_FILE)
                Marshal.load( File.read(STATE_FILE) )
              else
                Project.new
              end

    # Drop the user in a prompt and process commands as they are entered
    prompt = 'rg> '
    while line = Readline.readline(prompt, true)
      args = line.split
      command = args.shift

      case command
      when 'add'
        # rg> add git@gitlab.com:lycoperdon/foo.git
        project.add_repo(args.shift)
      when 'target'
        # rg> target rails 4.2.7
        (target_gem, target_version) = *args
        project.set_target(target_gem, target_version)
        prompt = "rg #{target_gem}@#{target_version}> "
      when 'status'
        project.show_status
      when 'help'
        RailGrinder.show_help
      when /exit|quit/
        project.save_state
        puts "Goodbye..."
        break
      else
        puts "I'm sorry, I don't know about that command"
        RailGrinder.show_help
      end
    end

    # TODO:
    # Clean out after testing...
    # `rm -rf repos/{*,.*}
  end
end
