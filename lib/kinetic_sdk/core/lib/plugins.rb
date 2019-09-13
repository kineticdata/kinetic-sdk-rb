module KineticSdk
  class Core

    # Find plugins
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_plugins(params={}, headers=default_headers)
      @logger.info("Finding plugins.")
      # Find Plugins
      get("#{@api_url}/plugins", params, headers)
    end

    # Find plugins by service type
    #
    # @param service_type [String] service type of the plugins
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_plugins_by_service_type(service_type, params={}, headers=default_headers)
      @logger.info("Finding \"#{service_type}\" plugins.")
      # Find Plugins by service type
      get("#{@api_url}/plugins/#{encode(service_type)}", params, headers)
    end

    # Add a plugin via proxy through service endpoint
    #
    # @param service_endpoint_slug [String] slug of the service endpoint
    # @param proxy_api_route [String] API route to append to the service endpoint url
    # @param body [Hash] properties of the plugin
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_plugin(service_endpoint_slug, proxy_api_route, body, headers=default_headers)
      @logger.info("Add plugin via proxy through service endpoint \"#{service_endpoint_slug}\".")
      # Add the plugin via proxy through service endpoint
      post("#{@proxy_url}/#{service_endpoint_slug}#{proxy_api_route}", body, headers)
    end

    # Update a plugin via proxy through service endpoint
    #
    # @param service_endpoint_slug [String] slug of the service endpoint
    # @param proxy_api_route [String] API route to append to the service endpoint url
    # @param body [Hash] properties of the plugin
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_plugin(service_endpoint_slug, proxy_api_route, body, headers=default_headers)
      @logger.info("Update plugin via proxy through service endpoint \"#{service_endpoint_slug}\".")
      # Update the plugin via proxy through service endpoint
      put("#{@proxy_url}/#{service_endpoint_slug}#{proxy_api_route}", body, headers)
    end

    # Delete a plugin via proxy through service endpoint
    #
    # @param service_endpoint_slug [String] slug of the service endpoint
    # @param proxy_api_route [String] API route to append to the service endpoint url
    # @param body [Hash] properties of the plugin
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_plugin(service_endpoint_slug, proxy_api_route, body, headers=default_headers)
      @logger.info("Delete plugin via proxy through service endpoint \"#{service_endpoint_slug}\".")
      # Delete the plugin via proxy through service endpoint
      delete("#{@proxy_url}/#{service_endpoint_slug}#{proxy_api_route}", body, headers)
    end

  end
end
