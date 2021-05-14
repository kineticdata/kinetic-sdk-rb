###################################  TO RUN  ###################################
#
# 1. Ensure ruby (or jruby) is installed
# 2. Create a yaml file in the 'config' directory (will be omitted from git)
# 3. Ensure the translations.csv file existing in 'exports/SPACE-SLUG'
# 4. ruby import-translations.rb \
#      -s <space-slug> \
#      -c <config-file-name.yaml>
################################################################################

require 'optparse'
require 'ostruct'
require 'yaml'

class ImportOptions

  def self.parse(args)
    args << '-h' if args.empty?

    options = OpenStruct.new
    options.space_slug = nil

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: import-translations.rb [options]"
      opts.separator ""
      opts.on("-s SPACE_SLUG",
              "The slug of the Space to import") do |slug|
        options.space_slug = slug
      end
      opts.separator ""
      opts.on("-c CONFIG_FILE",
              "The config file to use for the import") do |cfg_file|
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


# Determine the directory of this file
pwd = File.expand_path(File.dirname(__FILE__))


# Require the SDK
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

# Get the configuration file
config_file = "#{pwd}/config/#{options.cfg}"
begin
  config = YAML.load_file(config_file)
rescue Exception => e
  puts "There was a problem with the configuration file #{options.cfg}: #{e.inspect}"
  exit
end

# variables
host = config["core"]["server"]
space_slug = options.space_slug
username = config["core"]["space_admin_credentials"]["username"]
password = config["core"]["space_admin_credentials"]["password"]
log_level = ENV['SDK_LOG_LEVEL'] || config["sdk_log_level"] || "off"
space_dir = File.join(pwd, "exports", space_slug)
filename = File.join(space_dir, "translations.csv")


# create a core Http client, this isn't really needed for this example,
# but it builds the base API URL for use automatically
core_http = KineticSdk::Core.new({
  space_server_url: "#{host.gsub("https://", "https://#{space_slug}.")}",
  space_slug: space_slug,
  username: username,
  password: password
})

# use a custom Http client because the translations SDK doesn't yet exist
custom_http = KineticSdk::CustomHttp.new({
  username: username,
  password: password,
  options: {
    log_level: log_level
  }
})

# open the file
raise "The file does not exist: #{filename}" if !File.exist?(filename)
raise "The file exists but is not readable: #{filename}" if !File.readable?(filename)
file = File.open(filename, 'r')

# import the data
path = "#{core_http.api_url}/translations/entries?import=csv"
response = custom_http.post_multipart(path, { "file" => file }, custom_http.default_headers)
if response.status != 200
  raise "Unable to import translations: #{response.inspect}"
end
puts "Translations imported from #{filename}"

# close the file
file.close if !file.nil?
