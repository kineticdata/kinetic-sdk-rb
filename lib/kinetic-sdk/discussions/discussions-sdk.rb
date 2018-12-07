Dir[File.join(File.dirname(File.expand_path(__FILE__)), "lib", "**", "*.rb")].each {|file| require file }

module KineticSdk

  # Discussions is a Ruby class that acts as a wrapper for the Kinetic Discussions REST API
  # without having to make explicit HTTP requests.
  #
  class Discussions

    # Include the KineticHttpUtils module
    include KineticSdk::Utils::KineticHttpUtils

    attr_reader :api_url, :username, :jwt, :options, :space_slug,
                :server, :topics_ws_server, :version

    # Initalize the Discussions SDK with the web server URL and configuration user
    # credentials, along with any custom option values.
    #
    # @param opts [Hash] Kinetic Discussions properties
    # @option opts [String] :config_file optional - path to the YAML configuration file
    #
    #   * Ex: /opt/config/discussions-configuration1.yaml
    #
    # @option opts [String] :app_server_url the URL to the Kinetic Request CE web space
    #
    #   * Ex: <http://192.168.0.1:8080/kinetic/acme> - space slug (`acme`)
    #   * Ex: <http://acme.server.io/kinetic> - space slug (`acme`) as subdomain
    #
    # @option opts [String] :space_slug the slug that identifies the Space
    # @option opts [String] :username the username for the user
    # @option opts [String] :password the password for the user
    # @option opts [Hash<Symbol, Object>] :options ({}) optional settings
    #
    #   * :log_level (String) (_defaults to: off_) level of logging - off | info | debug | trace
    #   * :max_redirects (Fixnum) (_defaults to: 10_) maximum number of redirects to follow
    #   * :ssl_ca_file (String) full path to PEM certificate used to verify the server
    #   * :ssl_verify_mode (String) (_defaults to: none_) - none | peer
    #
    # Example: using a configuration file
    #
    #     KineticSdk::Discussions.new({
    #       config_file: "/opt/config1.yaml"
    #     })
    #
    # Example: space user properties hash
    #
    #     KineticSdk::Discussions.new({
    #       app_server_url: "http://localhost:8080",
    #       space: "foo",
    #       username: "admin",
    #       password: "admin",
    #       options: {
    #         log_level: "debug",
    #         ssl_verify_mode: "peer",
    #         ssl_ca_file: "/usr/local/self_signing_ca.pem"
    #       }
    #     })
    #
    #
    # Example: system user properties hash
    #
    #     KineticSdk::Discussions.new({
    #       app_server_url: "http://localhost:8080",
    #       username: "admin",
    #       password: "password",
    #       options: {
    #           log_level: "debug",
    #           ssl_verify_mode: "peer",
    #           ssl_ca_file: "/usr/local/self_signing_ca.pem"
    #       }
    #     })
    #
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

      # allow either :app_server_url or :space_server_url, but not both
      if options[:app_server_url] && options[:space_server_url]
        raise StandardError.new "Expecting one of :app_server_url or :space_server_url, but not both."
      end
      if options[:app_server_url].nil? && options[:space_server_url].nil?
        raise StandardError.new "Expecting one of :app_server_url or :space_server_url."
      end

      # process any individual options
      @options = options.delete(:options) || {}
      @username = options[:username]
      @space_slug = options[:space_slug]

      if options[:topics_server_url]
        @topics_ws_server = "#{options[:topics_server_url].gsub('http', 'ws')}/#{@space_slug}/socket"
      end

      if options[:discussions_server_url]
        @server = options[:discussions_server_url].chomp('/')
        @api_url = "#{@server}/#{@space_slug}/app/api/v1"
        if @topics_ws_server.nil?
          @topics_ws_server = "#{@server.gsub('http', 'ws')}/app/topics/socket"
        end
      elsif options[:app_server_url]
        @server = options[:app_server_url].chomp('/')
        @api_url = "#{@server}/#{@space_slug}/app/api/v1"
        if @topics_ws_server.nil?
          @topics_ws_server = "#{@server.gsub('http', 'ws')}/#{@space_slug}/app/topics/socket"
        end
      else
        raise StandardError.new "The :space_slug option is required when using the :space_server_url option" if @space_slug.nil?
        @server = options[:space_server_url].chomp('/')
        @api_url = "#{@server}/app/discussions/api/v1"
        if @topics_ws_server.nil?
          @topics_ws_server = "#{@server.gsub('http', 'ws')}/app/topics/socket"
        end
      end
      @jwt = @space_slug.nil? ? nil : generate_jwt(options)
      @version = 1
    end

    # Generate a JWT for bearer authentication based on the user credentials,
    # and oauth client configuration.
    def generate_jwt(options={})
      oauth_client_id = options[:oauth_client_id]
      oauth_client_secret = options[:oauth_client_secret]

      jwt_response = kinetic_core_sdk(options).jwt_token(oauth_client_id, oauth_client_secret)
      jwt_response.content['access_token']
    end

    # Creates a reference to the Kinetic Request CE SDK
    def kinetic_core_sdk(options)
      kinetic_core_options = {
        space_slug: options[:space_slug],
        username: options[:username],
        password: options[:password],
        options: {
          log_level: options[:sdk_level] || "off"
        }
      }
      if options[:app_server_url]
        kinetic_core_options[:app_server_url] = options[:app_server_url]
      else
        kinetic_core_options[:space_server_url] = options[:space_server_url]
      end
      KineticSdk::RequestCe.new(kinetic_core_options)
    end
    
  end
end
