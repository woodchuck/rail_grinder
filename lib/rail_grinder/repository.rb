module RailGrinder
  class Repository

    def initialize(url, repo_dir)
      # Use repo name for dir name to clone into
      # pull out to testable function (in lib/ ?)
      name = if url =~ %r|/([^/]+)\.git|
               Regexp.last_match[1]
             end
      unless name
        raise "Couldn't guess name of app"
      end

      if url
        system "git clone #{url} #{repo_dir}/#{name}"
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

  end
end
