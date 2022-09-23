###################################  TO RUN  ###################################
#
# This driver file assumes the Kinetic SDK is located in the relative directory:
#   - vendor/kinetic-sdk-rb
#
#
# 1. Ensure ruby (or jruby) is installed
# 2. Create a yaml file in the 'config' directory (will be omitted from git)
# 3. Ensure the 'exports' directory exists
# 4. Clone the platform-template Github repository into the 'exports' directory,
#    and name it 'platform_template' (e.g. exports/platform_template)
# 5. ruby import-kapp.rb \
#      -e template \
#      -s <space-slug> \
#      -k <kapp-slug> \
#      -c <config-file-name.yaml>
################################################################################

require 'erb'
require 'fileutils'
require 'json'
require 'optparse'
require 'ostruct'
require 'pp'
require 'time'
require 'yaml'


class ImportOptions

  #
  # Return a structure describing the options.
  #
  def self.parse(args)

    args << '-h' if args.empty?

    # The options specified on the command line will be collected in *options*.
    # We set default values here.
    options = OpenStruct.new
    options.export_space_slug = nil
    options.space_slug = nil
    options.kapp_slug = nil
    options.import_overwrite = false

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: import-kapp.rb [options]"

      opts.separator ""

      opts.on("-e EXPORT_SPACE_SLUG",
        "The slug of the exported Space",
        "  This is used to retrieve the data files") do |slug|
        options.export_space_slug = slug
      end

      opts.on("-s SPACE_SLUG",
              "The slug of the existing Space to import to") do |slug|
        options.space_slug = slug
      end

      opts.on("-k KAPP_SLUG",
        "The slug of the Kapp to import") do |slug|
        options.kapp_slug = slug
      end

      opts.on("-c CONFIG_FILE",
              "The config file to use for the export (must be in ./config directory)") do |cfg_file|
        options.cfg = cfg_file
      end

      opts.separator ""
      # No argument, shows at tail.  This will print an options summary.
      # Try it and see!
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
  puts "Cannot find the kinetic-sdk"
  exit
end

# Parse options from command line arguments
options = ImportOptions.parse(ARGV)

# Get Space Name / Slug and Export Space Slug
export_space_slug = options.export_space_slug
space_slug = options.space_slug
kapp_slug = options.kapp_slug

# Get the environment file
config_file = "#{pwd}/config/#{options.cfg}"
env = nil
begin
  env = YAML.load(ERB.new(open(config_file).read).result(binding))
rescue
  puts "There was a problem loading the configuration file #{options.cfg}: #{$!}"
  exit
end

# Build and move to the Export Directory for this space
space_dir = "#{pwd}/exports/#{export_space_slug}"
Dir.chdir(space_dir)

# SDK Logging
log_level = ENV['SDK_LOG_LEVEL'] || env['sdk_log_level'] || "info"

# Core
ce_server = env["core"]["server"]
ce_space_server = (env["proxy_subdomains"] || false) ?
  ce_server.gsub("://", "://#{space_slug}.") :
  "#{ce_server}/#{space_slug}"
# Get the Core configurator user credentials from an external file
ce_credentials = {
  "username" => env["core"]["system_credentials"]["username"],
  "password" => env["core"]["system_credentials"]["password"]
}
# Get the Core space user credentials from an external file
ce_credentials_space_admin = {
  "username" => env["core"]["space_admin_credentials"]["username"],
  "password" => env["core"]["space_admin_credentials"]["password"]
}


#--------------------------------------------------------------------------
# Core
#--------------------------------------------------------------------------
requestce_sdk_system = KineticSdk::Core.new({
  app_server_url: ce_server,
  username: ce_credentials["username"],
  password: ce_credentials["password"],
  options: { log_level: log_level }
})

# Check if the space exists
space_exists = requestce_sdk_system.space_exists?(space_slug)

if space_exists
  # Log into the Space with the Space Admin user
  requestce_sdk_space = KineticSdk::Core.new({
    space_server_url: ce_space_server,
    space_slug: space_slug,
    username: ce_credentials_space_admin["username"],
    password: ce_credentials_space_admin["password"],
    options: { log_level: log_level }
  })

  # check if the Kapp exists
  kapp_response = request_sdk_space.find_kapp(kapp_slug)
  if kapp_response.status == 404

    # Import Kapp
    Dir["#{core_dir}/kapp-#{kapp_slug}"].each do |dirname|

      # Import Kapp
      kapp = JSON.parse(File.read("#{dirname}/kapp.json"))

      # Add Category Attribute Definitions
      kapp['categoryAttributeDefinitions'] =
        JSON.parse(File.read("#{dirname}/categoryAttributeDefinitions.json"))

      # Add Form Attribute Definitions
      kapp['formAttributeDefinitions'] =
        JSON.parse(File.read("#{dirname}/formAttributeDefinitions.json"))

      # Add Kapp Attribute Definitions
      kapp['kappAttributeDefinitions'] =
        JSON.parse(File.read("#{dirname}/kappAttributeDefinitions.json"))

      # Add the Kapp
      requestce_sdk_space.add_kapp(kapp['name'], kapp_slug, kapp)

      # Add Categories
      JSON.parse(File.read("#{dirname}/categories.json")).each do |category|
        requestce_sdk_space.add_category_on_kapp(kapp_slug, category)
      end

      # Add Form Types
      requestce_sdk_space.delete_form_types_on_kapp(kapp_slug)
      JSON.parse(File.read("#{dirname}/formTypes.json")).each do |form_type|
        requestce_sdk_space.add_form_type_on_kapp(kapp_slug, form_type)
      end

      # Add Security Policy Definitions
      requestce_sdk_space.delete_security_policy_definitions(kapp_slug)
      JSON.parse(File.read("#{dirname}/securityPolicyDefinitions.json")).each do |policy|
        requestce_sdk_space.add_security_policy_definition(kapp_slug, {
          "name" => policy['name'],
          "message" => policy['message'],
          "rule" => policy['rule'],
          "type" => policy['type']
        })
      end

      # Import Forms
      Dir["#{dirname}/forms/*"].each do |form|
        requestce_sdk_space.add_form(kapp_slug, JSON.parse(File.read("#{form}")))
      end

      # Import Submissions
      submissions_count = 0
      Dir["#{dirname}/data/*"].each do |form|
        # Parse form slug from directory path
        form_slug = File.basename(form, '.json')
        puts "Importing submissions for: #{form_slug}"
        # Each submission is a single line on the export file
        File.readlines(form).each do |line|
          submission = JSON.parse(line)
          requestce_sdk_space.add_submission(kapp_slug, form_slug, {
            "origin" => submission['origin'],
            "parent" => submission['parent'],
            "values" => submission['values']
          })
          if (submissions_count += 1) % 25 == 0
            puts "Resetting the Core license submission count"
            requestce_sdk_system.reset_license_count
          end
        end
      end

      # Import Kapp Webhooks
      JSON.parse(File.read("#{dirname}/webhooks.json")).each do |webhook|
        requestce_sdk_space.add_webhook_on_kapp(kapp_slug, webhook)
      end
    end

    requestce_sdk_space.find_webhooks_on_kapp(kapp_slug).content['webhooks'].each do |webhook|
      url = webhook['url']
      # if the webhook contains a Kinetic Task URL
      if url.include?('/kinetic-task/app/api/v1')
        # replace the server/host portion
        apiIndex = url.index('/app/api/v1')
        url = url.sub(url.slice(0..apiIndex-1), task_server)
        # update the webhook
        requestce_sdk_space.update_webhook_on_kapp(kapp_slug, webhook['name'], {
          "url" => url,
          # add the signature access key
          "authStrategy" => {
            "type" => "Signature",
            "properties" => [
              { "name" => "Key", "value" => task_access_key['identifier'] },
              { "name" => "Secret", "value" => task_access_key['secret'] }
            ]
          }
        })
      end
    end

  else
    puts "The #{space_slug} :: #{kapp_slug} Kapp already exists, skipping Kapp import."
  end
else
  puts "The #{space_slug} space doesn't exist, skipping Kapp import."
end
