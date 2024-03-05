# Script to brute force delete Kinetic Task runtime data.
# 
# Running with Ruby:
#   1. Install Ruby >= 2.3
#   2. ruby task-bruteforce-runtime-cleanup.rb 123
#
#
# Running with Java:
#   1. Install Java 8 (either JRE or SDK)
#   2. Download JRuby complete jar: 
#        https://repo1.maven.org/maven2/org/jruby/jruby-complete/9.2.13.0/jruby-complete-9.2.13.0.jar
#   3. java -jar jruby-complete-9.2.13.0.jar -S task-bruteforce-runtime-cleanup.rb 123
#
#


#-----------------------------------------------------------------------------
# REQUIRED LIBRARIES / GEMS
#-----------------------------------------------------------------------------

require 'erb'
require 'io/console'
require "optparse"
require "ostruct"
require "yaml"


begin
  require 'kinetic_sdk'
rescue LoadError => e
  if !defined? KineticSdk
    puts "Installing the Kinetic SDK"
    Gem.install("kinetic_sdk")
    Gem.clear_paths
    retry
  end
end



#-----------------------------------------------------------------------------
# OPTIONS
#-----------------------------------------------------------------------------

class Options
  def self.parse(args)
    args << '-h' if args.empty?
    options = OpenStruct.new
    parser = OptionParser.new do |opts|
      opts.banner = "Usage: task-bruteforce-runtime-cleanup.rb FIRST_RUN_ID [LAST_RUN_ID]"
      opts.banner << "\n\nFIRST_RUN_ID"
      opts.banner << "\n    `1234567` id of the first run id to delete - REQUIRED"
      opts.banner << "\n\nLAST_RUN_ID"
      opts.banner << "\n    `1` id of the last run id to delete (default 1) - OPTIONAL"
      opts.banner << "\n    MUST be <= to FIRST_RUN_ID"


      opts.separator ""
      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end
    parser.parse!(args)

    # return the options
    return options, parser
  end
end



#-----------------------------------------------------------------------------
# SCRIPT HELPER METHODS
#-----------------------------------------------------------------------------

def get_char
  input = STDIN.getch
  control_c_code = "\u0003"
  exit(1) if input == control_c_code
  input
end


#-----------------------------------------------------------------------------
# BEGIN SCRIPT
#-----------------------------------------------------------------------------

# Parse options from command line arguments
options, parser = Options.parse(ARGV)


# Validate arguments
if ARGV.size < 1; puts parser.help; exit; end

# ID of the first task run to delete - all previous runs up to #{last_run_id} will also be deleted
first_run_id = ARGV.shift.to_i
# ID of the last task run to delete - default is 1
last_run_id = ARGV.empty? ? 1 : ARGV.shift.to_i
last_run_id = 1 if last_run_id < 1

# Validate the last_run_id is before the first_run_id
if last_run_id > first_run_id; puts parser.help; exit; end


# Determine the directory where this script resides, and the resources directory
pwd = File.expand_path(File.dirname(__FILE__))


# Load the configuration file
config_file = File.join(pwd, "config.yaml")
begin
  config = YAML.load_file(config_file)
  raise "The 'taskUrl' configuration property is missing" if config['taskUrl'].nil?
  raise "The 'username' configuration property is missing" if config['username'].nil?
rescue Exception => e
  raise "Failed to load the #{config_file} configuration file, #{e.inspect}"
end


# configure the Task SDK to match the Kinetic Task server
sdk = KineticSdk::Task.new({
  app_server_url: config['taskUrl'],
  username: config['username'],
  password: config['password'],
  options: {
    log_level: config['logLevel'] || "info"
  }
})


started_at = Time.now
count = 0
run_id = first_run_id


sdk.logger.info "--------------------------------------------------------------"
sdk.logger.info "Task Runtime Data Cleanup"
sdk.logger.info "  Task Server: #{sdk.server}"
sdk.logger.info "  Using Kinetic SDK #{KineticSdk::VERSION}"
sdk.logger.info "  Deleting runs #{first_run_id} to #{last_run_id}"
sdk.logger.info "--------------------------------------------------------------"


# Display warning, and wait for confirmation
puts "\nWARNING: This is a destructive operation. Kinetic Task run data will be deleted."
print "Are you sure you want to continue (y/n): "
ack = get_char()
puts
exit(1) if ack.downcase != "y"


begin
  # loop until the last_run_id is deleted
  loop do
    
    # break out of the loop if all runs have been processed
    break if run_id < last_run_id || run_id == 0

    # delete the run
    results = sdk.delete_run(run_id)

    # handle API exceptions
    if results.status == 200
      # increment the counter
      count = count + 1
    elsif results.status == 404
      sdk.logger.info "Run #{run_id} doesn't exist, skipping"
    elsif results.status != 200
      raise "Failed to delete run #{run_id}: (#{results.status}) #{results.message}" 
    elsif !results.exception.nil?
      raise "Failed to retrieve run #{run_id}: #{results.exception.inspect}"
    end

    # set the next run id
    run_id = run_id - 1
  end
rescue => e
  sdk.logger.info "Exception was encountered: #{e.inspect}\n#{e.backtrace.join("\n")}"
ensure
  duration = "%.3f" % ((Time.now - started_at).to_f)
  sdk.logger.info "--------------------------------------------------------------"
  sdk.logger.info "Finished deleting #{count} runs in (#{duration} sec)"
  sdk.logger.info "    Started at run #{first_run_id}"
  sdk.logger.info "    Ended at run #{last_run_id}"
  sdk.logger.info "--------------------------------------------------------------"
end
