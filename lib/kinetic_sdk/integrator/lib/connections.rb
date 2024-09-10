module KineticSdk
  class Integrator

    # Add a Connection
    #
    # @param properties [Hash] connection properties
    #   - +type+ [String]
    #   - +name+ [String]
    #   - +config+ [Hash]
    #     - +baseUrl+ [String] url to the server hosting the connection API
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_connection(properties={}, headers=default_jwt_headers)
      @logger.info("Adding the #{properties['type']} connection named #{properties['name']}")
      post("#{@api_url}/connections", properties, headers)
    end

    # Delete a connection
    #
    # @param connection_id [String] id of the connection
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_connection(connection_id, headers=default_jwt_headers)
      @logger.info("Deleting Connection \"#{connection_id}\"")
      delete("#{@api_url}/connections/#{connection_id}", headers)
    end

    # Find Connections
    #
    # @param params [Hash] Query parameters that are added to the URL
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_connections(params={}, headers=default_jwt_headers)
      @logger.info("Finding Connections")
      get("#{@api_url}/connections", params, headers)
    end

    # Find a Connection
    #
    # @param connection_id [String] id of the Connection
    # @param params [Hash] Query parameters that are added to the URL
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_connection(connection_id, params={}, headers=default_jwt_headers)
      @logger.info("Finding Connection \"#{connection_id}\"")
      get("#{@api_url}/connections/#{connection_id}", params, headers)
    end

    # Update a Connection
    #
    # @param connection_id [String] id of the Connection
    # @param properties [Hash] form properties to update
    #   - +name+ [String]
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_connection(connection_id, properties={}, headers=default_jwt_headers)
      @logger.info("Updating Connection \"#{connection_id}\"")
      put("#{@api_url}/connections/#{connection_id}", properties, headers)
    end

  end
end
