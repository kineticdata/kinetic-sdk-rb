Dir[File.join(File.dirname(File.expand_path(__FILE__)), "lib", "**", "*.rb")].each { |file| require file }

module KineticSdk

  # Integrator is a Ruby class that acts as a wrapper for the Kinetic Integrator REST API
  # without having to make explicit HTTP requests.
  #
  class Integrator

    # Include the KineticHttpUtils module
    include KineticSdk::Utils::KineticHttpUtils

    attr_reader :api_url, :username, :jwt, :options, :space_slug,
                :server, :version, :logger

    # Initalize the Integrator SDK with the web server URL and configuration user
    # credentials, along with any custom option values.
    #
    # @param opts [Hash] Kinetic Integrator properties
    # @option opts [String] :config_file optional - path to the YAML configuration file
    #
    #   * Ex: /opt/config/integrator-configuration1.yaml
    #
    # @option opts [String] :app_server_url the URL to the integrator server
    # @option opts [String] :space_server_url the URL to the Kinetic Request CE web space
    #
    #   * Ex: <http://192.168.0.1:8080/kinetic/acme> - space slug (`acme`)
    #   * Ex: <http://acme.server.io/kinetic> - space slug (`acme`) as subdomain
    #
    # @option opts [String] :space_slug the slug that identifies the Space
    # @option opts [String] :username the username for the user
    # @option opts [String] :password the password for the user
    # @option opts [Hash<Symbol, Object>] :options ({}) optional settings
    #
    #   * :export_directory (String) (_example: /opt/exports/integrator) directory to write files when exporting,
    #   * :gateway_retry_limit (FixNum) (_defaults to: 5_) max number of times to retry a bad gateway
    #   * :gateway_retry_delay (Float) (_defaults to: 1.0_) number of seconds to delay before retrying a bad gateway
    #   * :log_level (String) (_defaults to: off_) level of logging - off | error | warn | info | debug
    #   * :log_output (String) (_defaults to: STDOUT_) where to send output - STDOUT | STDERR
    #   * :max_redirects (Fixnum) (_defaults to: 5_) maximum number of redirects to follow
    #   * :oauth_client_id (String) id of the Kinetic Core oauth client
    #   * :oauth_client_secret (String) secret of the Kinetic Core oauth client
    #   * :ssl_ca_file (String) full path to PEM certificate used to verify the server
    #   * :ssl_verify_mode (String) (_defaults to: none_) - none | peer
    #
    # Example: using a configuration file
    #
    #     KineticSdk::Integrator.new({
    #       config_file: "/opt/config1.yaml"
    #     })
    #
    # Example: space user properties hash
    #
    #     KineticSdk::Integrator.new({
    #       space_server_url: "https://my-space.domain",
    #       space_slug: "my-space",
    #       username: "admin",
    #       password: "password",
    #       options: {
    #           log_level: "debug",
    #           oauth_client_id: "my-oauth-user-id",
    #           oauth_client_secret: "my-oauth-user-secret",
    #           ssl_verify_mode: "peer",
    #           ssl_ca_file: "/usr/local/self_signing_ca.pem"
    #       }
    #     })
    #
    # If the +config_file+ option is present, it will be loaded first, and any additional
    # options will overwrite any values in the config file
    #
    def initialize(opts)
      # initialize any variables
      options = {}

      # process the configuration file if it was provided
      unless opts[:config_file].nil?
        options.merge!(YAML::load_file opts[:config_file])
      end

      # process the configuration hash if it was provided
      options.merge!(opts)

      # allow one of :app_server_url, :space_server_url, or :integrator_server_url
      # but not more than one
      if options[:app_server_url] && options[:space_server_url]
        raise StandardError.new "Expecting either :app_server_url or :space_server_url, but not both."
      end

      if options[:app_server_url].nil? && options[:space_server_url].nil?
        raise StandardError.new "Expecting either :app_server_url or :space_server_url."
      end

      # process any individual options
      @options = options[:options] || {}
      # setup logging
      log_level = @options[:log_level] || @options["log_level"]
      log_output = @options[:log_output] || @options["log_output"]
      @logger = KineticSdk::Utils::KLogger.new(log_level, log_output)

      @username = options[:username]
      @space_slug = options[:space_slug]

      if options[:app_server_url]
        @server = options[:app_server_url].chomp("/")
        @api_url = "#{@server}/api"
      else
        raise StandardError.new "The :space_slug option is required when using the :space_server_url option" if @space_slug.nil?
        @server = options[:space_server_url].chomp("/")
        @api_url = "#{@server}/app/integrator/api"
      end
      @jwt = @space_slug.nil? ? nil : generate_jwt(options)
      @version = 1
    end

    # Generate a JWT for bearer authentication based on the user credentials,
    # and oauth client configuration.
    def generate_jwt(options = {})
      oauth_client_id = options[:options][:oauth_client_id]
      oauth_client_secret = options[:options][:oauth_client_secret]
      jwt_response = kinetic_core_sdk(options).jwt_token(oauth_client_id, oauth_client_secret)
      jwt_response.content["access_token"]
    end

    # Creates a reference to the Kinetic Request CE SDK
    def kinetic_core_sdk(options)
      kinetic_core_options = {
        space_slug: options[:space_slug],
        username: options[:username],
        password: options[:password],
        options: options[:options] || {},
      }
      if options[:app_server_url]
        kinetic_core_options[:app_server_url] = options[:app_server_url]
      else
        kinetic_core_options[:space_server_url] = options[:space_server_url]
      end
      KineticSdk::Core.new(kinetic_core_options)
    end
  end
end
