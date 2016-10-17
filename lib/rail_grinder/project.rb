require "rail_grinder/repository"

module RailGrinder
  class Project
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
      @repos = Repository.new(url, @repo_dir)
    end

    # Set the target gem that we want to update to the latest version in all
    # the repositories in the project.
    def set_target(gem, version)
      # TODO: validate
      @target_gem = gem
      @target_version = version
    end

    # Show the current status of all the repositories in the project. Show
    # the version of the target gem, whether tests have passed or failed,
    # whether the update has been committed, pushed, deployed, etc. in each
    # repository.
    def show_status
      # TODO: Iterate @repos instead?
      puts "You want '#{@target_gem}' at version #{@target_version}. Currently it's at:"
      proj_dir = Dir.pwd
      Dir.glob("#{@repo_dir}/*/Gemfile.lock").sort.each do |gemfile|
        app_dir = File.dirname(gemfile)
        Dir.chdir(File.join(proj_dir, app_dir))
        lockfile = Bundler::LockfileParser.new(
          Bundler.read_file(File.basename(gemfile))
        )

        lockfile.specs.each do |s|
          if s.name == @target_gem
            puts "#{s.version.to_s} : #{app_dir}"
            break
          end
        end
      end
    end

    def save_state
      open(RailGrinder::STATE_FILE, 'wb') { |f| f.puts Marshal.dump(self) }
    end
  end
end
