###################################  TO RUN  ###################################
#
# 1. Ensure ruby (or jruby) is installed
# 2. Create a yaml file in the 'config' directory (will be omitted from git)
#      - add / edit the paths to the trees you would like to import
# 3. ruby import-task-trees.rb \
#      -c <config-file-name.yaml> \
################################################################################

require 'fileutils'
require 'optparse'
require 'ostruct'


class ImportOptions
  def self.parse(args)
    args << '-h' if args.empty?
    options = OpenStruct.new
    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: import-task-trees.rb [options]"
      opts.separator ""
      opts.on("-c CONFIG_FILE",
              "The config file to use for the import (must be in ./config directory)") do |cfg_file|
        options.cfg = cfg_file
      end
      opts.separator ""
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end
    opt_parser.parse!(args)
    options
  end
end

# Determine the Present Working Directory
pwd = File.expand_path(File.dirname(__FILE__))

if Dir.exist?('vendor')
  # Require the Kinetic SDK from the vendor directory
  require File.join(pwd, 'vendor', 'kinetic-sdk-rb', 'kinetic-sdk')
elsif File.exist?(File.join(pwd, '../..', 'kinetic-sdk.rb'))
  # Assume this script is running from the samples directory
  require File.join(pwd, '../..', 'kinetic-sdk')
else
  # Try to require the Kinetic SDK gem
  begin
    require 'kinetic_sdk'
  rescue
    puts "Cannot find the kinetic-sdk"
    exit
  end
end

# Parse options from command line arguments
options = ImportOptions.parse(ARGV)

# Get the environment file
config_file = "#{pwd}/config/#{options.cfg}"
begin
  config = open(config_file)
  env = YAML.load(config.read)
rescue
  puts "The configuration file #{options.cfg} does not exist."
  exit
end

# SDK Logging
log_level = ENV['SDK_LOG_LEVEL'] || env['sdk_log_level'] || "info"

#--------------------------------------------------------------------------
# Task
#--------------------------------------------------------------------------

task_sdk = KineticSdk::Task.new(
  app_server_url: env["task"]["server"],
  username: env["task"]["credentials"]["username"],
  password: env["task"]["credentials"]["password"],
  options: {
    log_level: log_level
  }
)

trees = env["trees"] || []
overwrite_option = env["force_overwrite"] || false

trees.each do |tree_file|
  tree = File.new(tree_file, "rb")
  puts "Importing #{File.basename(tree)}"
  response =  task_sdk.import_tree(tree, overwrite_option)
  puts "#{response.status} #{response.content["message"]}" if response.status != 200
end
