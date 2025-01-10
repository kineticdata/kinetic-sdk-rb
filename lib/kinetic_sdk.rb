require 'fileutils'
require 'json'
require 'uri'
require 'yaml'

pwd = File.expand_path(File.dirname(__FILE__))
gemdir = File.expand_path(File.join(pwd, '..', 'gems'))

# add gem directories to load path if gem is not installed
if Gem::Specification.find_all_by_name('mime-types').empty?
  $:.unshift File.join(gemdir, 'mime-types-3.6.0', 'lib')
end
if Gem::Specification.find_all_by_name('mime-types-data').empty?
  $:.unshift File.join(gemdir, 'mime-types-data-3.2025.0107', 'lib')
end
if Gem::Specification.find_all_by_name('multipart-post').empty?
  $:.unshift File.join(gemdir, 'multipart-post-2.0.0', 'lib')
end
if Gem::Specification.find_all_by_name('slugify').empty?
  $:.unshift File.join(gemdir, 'slugify-1.0.7', 'lib')
end

require 'slugify'

require File.join(pwd, "kinetic_sdk/version")

require File.join(pwd, "kinetic_sdk/utils/logger")
require File.join(pwd, "kinetic_sdk/utils/kinetic-export-utils")
require File.join(pwd, "kinetic_sdk/utils/kinetic-http-headers")
require File.join(pwd, "kinetic_sdk/utils/kinetic-http-response")
require File.join(pwd, "kinetic_sdk/utils/kinetic-http")
require File.join(pwd, "kinetic_sdk/utils/prettier-xml-formatter")
require File.join(pwd, "kinetic_sdk/utils/random")

require File.join(pwd, "kinetic_sdk/agent/agent-sdk")
require File.join(pwd, "kinetic_sdk/bridgehub/bridgehub-sdk")
require File.join(pwd, "kinetic_sdk/core/core-sdk")
require File.join(pwd, "kinetic_sdk/discussions/discussions-sdk")
require File.join(pwd, "kinetic_sdk/filehub/filehub-sdk")
require File.join(pwd, "kinetic_sdk/integrator/integrator-sdk")
require File.join(pwd, "kinetic_sdk/task/task-sdk")
