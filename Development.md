# KineticSdk

To experiment with the Kinetic SDK code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kinetic_sdk'
```

And then execute:

```sh
bundle
```

Or install it yourself as:

```sh
gem install kinetic_sdk
```

To upgrade the kinetic_sdk gem to the latest version with bundler, simply run:

```sh
bundle update
```

Or update it to the latest version with the gem command:

```sh
gem update kinetic_sdk
```

Then in your application, include the SDK with the following code:

```ruby
require 'kinetic_sdk'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Versioning and Changelog

To release a new version, you must first checkout the git `master` branch and then update the version number in `version.rb`. [Rubygems.org](https://rubygems.org) does not allow updating a gem with the same version, you must always push a new version.

Update the `CHANGELOG.md` file with the release information.

After updating the version and changelog, you can then then build the gem.

### Building

Building the gem requires the following commands:

```sh
bundle install
bundle exec rake build
```

### Install to local gem directory

To install this gem onto your local machine, run the following command:

```sh
bundle exec rake install
```

### Pushing to Rubygems

Make sure a `~/.gem/credentials` file exists in your home directory that includes the `kineticdata` account credentials. If you don't have that file, find it in 1password.

Finally push the updated gem with the following command:

```sh
gem push pkg/kinetic_sdk-x.x.x.gem
```

### Git Release

After successfully pushing to Rubygems, commit your changes to the master branch and create a tag for the release.

* `git add .`
* `git commit -m "Prepare for 5.0.15 release`
* `git tag -a 5.0.15 -m "Tag 5.0.15"`
* `git push && git push --tags`
