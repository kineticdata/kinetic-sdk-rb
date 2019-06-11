require "bundler/gem_tasks"
require 'yard'

desc "Generate Documentation"
YARD::Rake::YardocTask.new do |t|
  # see .yardopts
  t.stats_options = %w( --list-undoc )
end

# Generate Yard documentation
task :doc => [:yard]
task :default => [:doc]
