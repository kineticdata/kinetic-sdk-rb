module KineticSdk
  class Core

    # Add a service endpoint
    #
    # @param body [Hash] properties of the service endpoint
    #   - +slug+ - slug of the service endpoint
    #   - +type+ - type of the service endpoint
    #   - +url+ - url of the service endpoint
    #   - +authenticationProperties+ - authentication properties for the authentication type
    #   - +authenticationType+ - type of authentication used by the service endpoint
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_service_endpoint(body, headers=default_headers)
      @logger.info("Adding service endpoint \"#{body['slug']}\".")
      # Create the service endpoint
      post("#{@api_url}/serviceEndpoints", body, headers)
    end

    # Delete a service endpoint
    #
    # @param slug [String] slug of the service endpoint
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_service_endpoint(slug, headers=default_headers)
      @logger.info("Deleting service endpoint \"#{slug}\".")
      # Delete the service endpoint
      delete("#{@api_url}/serviceEndpoints/#{slug}", body, headers)
    end

    # Find service endpoints
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_service_endpoints(params={}, headers=default_headers)
      @logger.info("Finding service endpoints.")
      # Find service endpoints
      get("#{@api_url}/serviceEndpoints", params, headers)
    end

    # Find a service endpoint
    #
    # @param slug [String] slug of the service endpoint
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_service_endpoint(slug, params={}, headers=default_headers)
      @logger.info("Finding service endpoint \"#{slug}\".")
      # Find service endpoint
      get("#{@api_url}/serviceEndpoints/#{slug}", params, headers)
    end

    # Update a service endpoint
    #
    # @param slug [String] slug of the service endpoint
    # @param body [Hash] properties of the service endpoint
    #   - +slug+ - slug of the service endpoint
    #   - +type+ - type of the service endpoint
    #   - +url+ - url of the service endpoint
    #   - +authenticationProperties+ - authentication properties for the authentication type
    #   - +authenticationType+ - type of authentication used by the service endpoint
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_service_endpoint(slug, body, headers=default_headers)
      @logger.info("Updating service endpoint \"#{slug}\".")
      # Update the service endpoint
      put("#{@api_url}/serviceEndpoints/#{slug}", body, headers)
    end

  end
end
