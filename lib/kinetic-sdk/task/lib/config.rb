module KineticSdk
  class Task

    # Find the database configuration
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_db(params={}, headers=header_basic_auth)
      info("Finding the database configuration")
      response = get("#{@api_url}/config/db", params, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
      response
    end


    # Find the session configuration properties
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_session_configuration(params={}, headers=header_basic_auth)
      info("Finding the session timeout")
      response = get("#{@api_url}/config/session", params, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
      response
    end


    # Update the authentication settings
    #
    # @param settings [Hash] Settings for the authenticator
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     update_authentication({
    #       "authenticator" => "com.kineticdata.core.v1.authenticators.ProxyAuthenticator",
    #       "authenticationJsp" => "/WEB-INF/app/login.jsp",
    #       "properties" => {
    #         "Authenticator[Authentication Strategy]" => "Http Header",
    #         "Authenticator[Header Name]" => "X-Login",
    #         "Authenticator[Guest Access Enabled]" => "No"
    #       }
    #     })
    #
    def update_authentication(settings, headers=default_headers)
      info("Updating the authentication properties")
      response = put("#{@api_url}/config/auth", settings, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
      response
    end


    # Update the database configuration
    #
    # This assumes the database has already been created on the dbms.
    #
    # @param settings [Hash] Setting sfor the selected type of dbms
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     update_db({
    #       "hibernate.connection.driver_class" => "org.postgresql.Driver",
    #       "hibernate.connection.url" => "jdbc:postgresql://192.168.0.1:5432",
    #       "hibernate.connection.username" => "my-db-user",
    #       "hibernate.connection.password" => "my-db-password",
    #       "hibernate.dialect" => "com.kineticdata.task.adapters.dbms.KineticPostgreSQLDialect"
    #     })
    #
    def update_db(settings, headers=default_headers)
      info("Updating the database properties")
      response = put("#{@api_url}/config/db", settings, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
      response
    end


    # Update the engine settings
    #
    # @param settings [Hash] Settings for the selected type of dbms
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     update_engine({
    #       "Max Threads" => "1",
    #       "Sleep Delay" => "10",
    #       "Trigger Query" => "'Selection Criterion'=null"
    #     })
    #
    def update_engine(settings, headers=default_headers)
      info("Updating the engine properties")
      return_result = []
      response_update = put("#{@api_url}/config/engine", settings, headers)
      return_result.push(response_update)
      if @options[:raise_exceptions] && [200].include?(response_update.status) == false
        raise "#{response_update.status} #{response_update.message}"
      end

      # start the task engine?
      if !settings['Sleep Delay'].nil? && settings['Sleep Delay'].to_i > 0
        info("Starting the engine")
        response_start = start_engine
        return_result.push(response_start)
        if @options[:raise_exceptions] && [200].include?(response_start.status) == false
          raise "#{response_start.status} #{response_start.message}"
        end
      end
      
      return_result
    end


    # Update the identity store settings
    #
    # @param settings [Hash] Settings for the identity store
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     update_identity_store({
    #       "Identity Store" => "com.kineticdata.authentication.kineticcore.KineticCoreIdentityStore",
    #       "properties" => {
    #         "Kinetic Core Space Url" => "http://server:port/kinetic/space",
    #         "Group Attribute Name" => "Group",
    #         "Proxy Username" => "admin",
    #         "Proxy Password" => "admin"
    #       }
    #     })
    #
    def update_identity_store(settings, headers=default_headers)
      info("Updating the identity store properties")
      response = put("#{@api_url}/config/identityStore", settings, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
      response
    end


    # Update the web server and default configuration user settings
    #
    # @param settings [Hash] Settings for the web server and configurator user
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     update_properties({
    #       "Configurator Username" => "my-admin-user",
    #       "Configurator Password" => "my-admin-pass",
    #       "Log Level" => "DEBUG",
    #       "Log Size (MB)" => "20"
    #     })
    #
    # Example
    #
    #     update_properties({
    #       "Configurator Username" => "my-admin-user",
    #       "Configurator Password" => "my-admin-pass"
    #     })
    #
    def update_properties(settings, headers=default_headers)
      info("Updating the web server properties")
      response = put("#{@api_url}/config/server", settings, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end

      # reset the configuration user
      @config_user = {
        username: settings["Configurator Username"],
        password: settings["Configurator Password"]
      }
      
      response
    end


    # Update the session configuration settings
    #
    # @param settings [Hash] Settings for the session configuration
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     update_session_configuration({
    #       "timeout" => "30"
    #     })
    #
    def update_session_configuration(settings, headers=default_headers)
      info("Updating the session configuration settings")
      response = put("#{@api_url}/config/session", settings, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
      response
    end

    # Find the system policy rule
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_system_policy_rule(params={}, headers=header_basic_auth)
      info("Finding the system policy rule")
      response = get("#{@api_url}/config/systemPolicyRule", params, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
      response
    end

    # Update the system policy rule
    #
    # @param policy_rule_name [String] name of the policy rule to use
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     update_system_policy_rule("Allow All")
    #
    def update_system_policy_rule(policy_rule_name, headers=default_headers)
      info("Updating the system policy rule")
      payload = { "name" => policy_rule_name }
      response = put("#{@api_url}/config/systemPolicyRule", payload, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
      response
    end

  end
end
