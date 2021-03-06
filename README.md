# RailGrinder

A [rail grinder](https://en.wikipedia.org/wiki/Railgrinder) grinds worn railroad rails to have a consistent profile. If you have a fleet of apps, this tool can help you manage the gem versions they use.

## Requirements

 * You will need cmake installed to compile the `rugged` gem's included version of libgit2.
 * Ruby >= 2.0

## Installation

    $ gem install rail_grinder

## Usage

    $ exe/rg
    Loading state from /home/steve/.rail_grinder
    rg :> add git@github.com:user/snazzy.git
    ...
    rg :> target rails 4.2.10
    rg rails:4.2.10> status
    You want 'rails' at version 4.2.10. Currently it's at:
    4.2.1 : /home/steve/.rail_grinder_repos/snazzy
    rg rails:4.2.10> update
    ...
    You want 'rails' at version 4.2.10. Currently it's at:
    4.2.10 : /home/steve/.rail_grinder_repos/snazzy
    rg rails:4.2.10> exit
    Saving state to /home/steve/.rail_grinder
    Goodbye...

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Todo

 * Run specs
 * Commit
 * Wrap this all up with a state machine

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

