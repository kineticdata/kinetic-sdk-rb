require "bundler/gem_tasks"
require 'yard'

desc "Generate Documentation"
YARD::Rake::YardocTask.new do |t|
  # see .yardopts
  t.stats_options = %w( --list-undoc )
end

# Run the specs. Guarded so the Rakefile still loads (and `rake build` still
# works) in an environment where the development dependencies are absent.
begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  desc "Run the specs (rspec is not installed)"
  task :spec do
    abort "rspec is not available. Run `bundle install` first."
  end
end

# Generate Yard documentation
task :doc => [:yard]
task :rdoc => [:yard]
task :default => [:spec, :doc]
