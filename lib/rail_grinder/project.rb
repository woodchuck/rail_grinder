require "rail_grinder/repository"
require "yaml"

module RailGrinder
  class Project
    # If there is saved project state, load it.
    # Otherwise create a new project.
    def Project.get
      if File.exist?(RailGrinder::STATE_FILE)
        puts 'Loading state from ' + RailGrinder::STATE_FILE
        YAML.load( File.read(RailGrinder::STATE_FILE) )
      else
        Project.new
      end
    end

    def initialize
      @repos = []
      @repo_dir = RailGrinder::REPO_DIR
      @target_gem = nil
      @target_version = nil

      if Dir.exist?(@repo_dir)
        puts "Repositories will be cloned to the existing './#{@repo_dir}' directory."
      else
        Dir.mkdir @repo_dir
        # TODO: handle failure to create dir?
        puts "A new './#{@repo_dir}' directory has been created to clone repositories into."
      end
    end

    # Add a git repository to the project.
    def add_repo(url)
      # TODO: Test if repo already exists.
      @repos << Repository.new(url, @repo_dir)
    end

    # Set the target gem that we want to update to the latest version in all
    # the repositories in the project.
    def set_target(gem, version)
      # TODO: validate
      @target_gem = gem
      @target_version = Gem::Version.new(version)
    end

    def get_target
      [@target_gem, @target_version]
    end

    # Show the current status of all the repositories in the project. Show
    # the version of the target gem, whether tests have passed or failed,
    # whether the update has been committed, pushed, deployed, etc. in each
    # repository.
    def show_status
      puts "You want '#{@target_gem}' at version #{@target_version}. Currently it's at:"
      @repos.each do |repo|
        puts "%s : %s" % [repo.version(@target_gem), repo.path]
      end
    end
    
    # Attempt to update all repos to have the specified gem at the specified
    # version including:
    #  - bundle update
    #  TODO:
    #  https://github.com/state-machines/state_machines
    #  - run and pass tests
    #  - commit
    #  - push
    #  - deploy
    def update
      @repos.each do |repo|
        if repo.version(@target_gem) < @target_version
          puts "Bundle updating #{@target_gem} in #{repo.path}..."
          repo.bundle_update(@target_gem)
        else 
          puts "#{@target_gem} is already up-to-date in #{repo.path}."
        end
      end
      show_status
    end

    def save_state
      puts 'Saving state to ' + RailGrinder::STATE_FILE
      File.write(RailGrinder::STATE_FILE, YAML.dump(self))
    end
  end
end
