require 'fileutils'
require 'json'
require 'uri'
require 'yaml'

pwd = File.expand_path(File.dirname(__FILE__))
gemdir = File.expand_path(File.join(pwd, '..', 'gems'))

# add gem directories to load path if gem is not installed
if Gem::Specification.find_all_by_name('mime-types').empty?
  $:.unshift File.join(gemdir, 'mime-types-3.1', 'lib')
end
if Gem::Specification.find_all_by_name('mime-types-data').empty?
  $:.unshift File.join(gemdir, 'mime-types-data-3.2016.0521', 'lib')
end
if Gem::Specification.find_all_by_name('multipart-post').empty?
  $:.unshift File.join(gemdir, 'multipart-post-2.0.0', 'lib')
end
if Gem::Specification.find_all_by_name('parallel').empty?
  $:.unshift File.join(gemdir, 'parallel-1.12.1', 'lib')
end
if Gem::Specification.find_all_by_name('ruby-progressbar').empty?
  $:.unshift File.join(gemdir, 'ruby-progressbar-1.9.0', 'lib')
end
if Gem::Specification.find_all_by_name('slugify').empty?
  $:.unshift File.join(gemdir, 'slugify-1.0.7', 'lib')
end
if Gem::Specification.find_all_by_name('kontena-websocket-client').empty?
  $:.unshift File.join(gemdir, 'kontena-websocket-client-0.1.1', 'lib')
end
if Gem::Specification.find_all_by_name('websocket-extensions').empty?
  $:.unshift File.join(gemdir, 'websocket-extensions-0.1.3', 'lib')
end
if Gem::Specification.find_all_by_name('websocket-driver').empty?
  if defined?(JRUBY_VERSION)
    $:.unshift File.join(gemdir, 'websocket-driver-0.6.5-java', 'lib')
  else
    $:.unshift File.join(gemdir, 'websocket-driver-0.6.5', 'lib')
  end
end

require 'parallel'
require 'slugify'

require File.join(pwd, "kinetic_sdk/version")

require File.join(pwd, "kinetic_sdk/utils/logger")
require File.join(pwd, "kinetic_sdk/utils/random")
require File.join(pwd, "kinetic_sdk/utils/kinetic-http-headers")
require File.join(pwd, "kinetic_sdk/utils/kinetic-http-response")
require File.join(pwd, "kinetic_sdk/utils/kinetic-http")

require File.join(pwd, "kinetic_sdk/bridgehub/bridgehub-sdk")
require File.join(pwd, "kinetic_sdk/discussions/discussions-sdk")
require File.join(pwd, "kinetic_sdk/filehub/filehub-sdk")
require File.join(pwd, "kinetic_sdk/request_ce/request-ce-sdk")
require File.join(pwd, "kinetic_sdk/task/task-sdk")
