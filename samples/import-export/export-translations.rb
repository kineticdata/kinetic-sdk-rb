###################################  TO RUN  ###################################
#
# 1. Ensure ruby (or jruby) is installed
# 2. Create a yaml file in the 'config' directory (will be omitted from git)
# 3. Ensure the 'exports' directory exists
# 4. ruby export-translations.rb \
#      -s <space-slug> \
#      -c <config-file-name.yaml>
################################################################################

require 'optparse'
require 'ostruct'
require 'yaml'

class ExportOptions

  def self.parse(args)
    args << '-h' if args.empty?

    options = OpenStruct.new
    options.space_slug = nil

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: export-translations.rb [options]"
      opts.separator ""
      opts.on("-s SPACE_SLUG",
              "The slug of the Space to export") do |slug|
        options.space_slug = slug
      end
      opts.separator ""
      opts.on("-c CONFIG_FILE",
              "The config file to use for the export") do |cfg_file|
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
options = ExportOptions.parse(ARGV)

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
# but it builds the base API URL automatically
core_http = KineticSdk::Core.new({
  space_server_url: "#{host.gsub(/(https?:\/\/)(.*)/, "\\1#{space_slug}\.\\2")}",
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

# export translations
path = "#{core_http.api_url}/translations/entries"
parameters = { "export" => "csv" }
response = custom_http.get(path, parameters, custom_http.default_headers)
if response.status != 200
  raise "Unable to export translations: #{response.inspect}"
end
exported_entries = response.content_string

# create directory if not exists and write the file
FileUtils.mkdir_p(space_dir, :mode => 0700)
File.open(filename, 'w') { |file| file.write(exported_entries) }
puts "Translations exported to #{filename}"
