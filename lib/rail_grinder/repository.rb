module RailGrinder
  # Get the base name of the repository from its url.
  # Module method rather than private class method so it makes a nice
  # testable unit.
  def RailGrinder.inferred_name(url)
    # Get the bit of the url after the last /
    name = if url =~ %r|/([^/]+)$|
             Regexp.last_match[1]
           end
    name.gsub!(/\.git$/, '')
    unless name
      raise "Couldn't guess name of app from the repo url"
    end
    name
  end

  # Represent a git repository. Handle cloning a repo into a project, and once
  # it's there, performing commits and pushes.
  class Repository
    def initialize(url, repo_dir)
      unless url
        raise "Please provide the url to a git repository.\n eg. $ rg.rb add git@gitlab.com:lycoperdon/foo.git"
      end
      @url = url
      @path = "#{repo_dir}/#{RailGrinder.inferred_name(@url)}"

      system "git clone #{@url} #{@path}"
      # Make sure the clone call went Ok
      if $CHILD_STATUS.signaled?
        puts "!! child died with signal %d, %s coredump" % [$CHILD_STATUS.termsig, $CHILD_STATUS.coredump? ? 'with' : 'without']
      elsif $CHILD_STATUS.exitstatus != 0
        puts "!! child exited with value %d\n" % [$CHILD_STATUS.exitstatus]
      end
    end
  end
end
