# KineticSdk

To experiment with the Kinetic SDK code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kinetic_sdk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kinetic_sdk

Then in your application, include the SDK with the following code:

```ruby
require 'kinetic_sdk'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

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

To release a new version, you must first update the version number in `version.rb`. [Rubygems.org](https://rubygems.org) does not allow updating a gem with the same version, you must always push a new version.

After updating the version, you must build the gem - see above.

Make sure a `~/.gem/credentials` file exists in your home directory that includes the `kineticdata` account credentials. If you don't have that file, find it in 1password.

Finally push the updated gem with the following command:

```sh
gem push pkg/kinetic_sdk-x.x.x.gem
```
