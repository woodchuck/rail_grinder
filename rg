#!/usr/bin/env ruby

require 'bundler/setup'
Bundler.setup

require 'awesome_print'
# TODO: Don't load this as a matter of course
require 'byebug'
require 'English'
require 'readline'
require 'rugged'

REPO_DIR = 'repos'

# Load configuration file if it exists.

puts "Repositories will be cloned to the './#{REPO_DIR}' directory."
if Dir.exist?(REPO_DIR)
  puts "Using the existing './#{REPO_DIR}' directory."
else
  Dir.mkdir REPO_DIR
  # TODO: handle failure to create dir?
  puts "#{REPO_DIR} created."
end

target_gem = nil
target_version = nil

def add_repo(url)
  # Use repo name for dir name to clone into
  # pull out to testable function (in lib/ ?)
  name = if url =~ %r|/([^/]+)\.git|
           Regexp.last_match[1]
         end
  unless name
    raise "Couldn't guess name of app"
  end

  if url
    system "git clone #{url} #{REPO_DIR}/#{name}"
    # Make sure the clone call went Ok
    if $CHILD_STATUS.signaled?
      raise "child died with signal %d, %s coredump" % [$CHILD_STATUS.termsig, $CHILD_STATUS.coredump? ? 'with' : 'without']
    elsif $CHILD_STATUS.exitstatus != 0
      raise "child exited with value %d\n" % [$CHILD_STATUS.exitstatus]
    end
  else
    raise "Please provide the url to a git repository.\n eg. $ rg.rb add git@gitlab.com:lycoperdon/foo.git"
  end
end

def status(gem, version)
  puts "You want '#{gem}' at version #{version}. Currently it's at:"
  Dir.glob("#{REPO_DIR}/*/Gemfile.lock").sort.each do |gemfile|
    app_dir = File.dirname(gemfile)
    Dir.chdir(app_dir)
    lockfile = Bundler::LockfileParser.new(
      Bundler.read_file(File.basename(gemfile))
    )

    lockfile.specs.each do |s|
      if s.name == gem
        puts "#{s.version.to_s} : #{app_dir}"
        break
      end
    end
  end
end

# Drop the user in a prompt and process commands as they are entered
prompt = 'rg> '
while line = Readline.readline(prompt, true)
  args = line.split
  command = args.shift

  case command
  when 'add'
    # rg> add git@gitlab.com:lycoperdon/foo.git
    add_repo(args.shift)
  when 'target'
    # rg> target rails 4.2.7
    # TODO: validate this
    (target_gem, target_version) = *args
    prompt = "rg #{target_gem}@#{target_version}> "
  when 'status'
    if target_gem
      status(target_gem, target_version)
    else
      puts "please invoke the `target` command first to choose a gem to list"
    end
  when /exit|quit/
    puts "Goodbye..."
    break
  else
    puts "I'm sorry, I don't know about that command"
    # TODO: Print help
  end
end

# TODO:
# Clean out after testing...
# `rm -rf repos/{*,.*}
