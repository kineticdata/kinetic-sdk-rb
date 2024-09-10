module KineticSdk
  class Integrator

    # Add an Operation
    #
    # @param connection_id [String] id of the Connection
    # @param properties [Hash] operation properties
    #   - +name+ [String]
    #   - +type+ [String]
    #   - +name+ [String]
    #   - +config+ [Hash]
    #     - +baseUrl+ [String] url to the server hosting the connection API
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_operation(connection_id, properties={}, headers=default_jwt_headers)
      @logger.info("Adding the #{properties['name']} operation")
      @logger.info("Operation properties: #{properties.inspect}")
      post("#{@api_url}/connections/#{connection_id}/operations", properties, headers)
    end

    # Delete an operation
    #
    # @param connection_id [String] id of the connection the operation belongs to
    # @param operation_id [String] id of the operation
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_operation(connection_id, operation_id, headers=default_jwt_headers)
      @logger.info("Deleting Operation \"#{operation_id}\"")
      delete("#{@api_url}/connections/#{connection_id}/operations/#{operation_id}", headers)
    end

    # Find Operations for a Connection
    #
    # @param connection_id [String] id of the connection the operation belongs to
    # @param params [Hash] Query parameters that are added to the URL
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_operations(connection_id, params={}, headers=default_jwt_headers)
      @logger.info("Finding Operations")
      get("#{@api_url}/connections/#{connection_id}/operations", params, headers)
    end

    # Find an Operation
    #
    # @param connection_id [String] id of the Connection
    # @param operation_id [String] id of the Operation
    # @param params [Hash] Query parameters that are added to the URL
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_operation(connection_id, operation_id, params={}, headers=default_jwt_headers)
      @logger.info("Finding Operation \"#{operation_id}\"")
      get("#{@api_url}/connections/#{connection_id}/operations/#{operation_id}", params, headers)
    end

    # Update an Operation
    #
    # @param connection_id [String] id of the Connection
    # @param operation_id [String] id of the Operation
    # @param properties [Hash] form properties to update
    #   - +name+ [String]
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_operation(connection_id, operation_id, properties={}, headers=default_jwt_headers)
      @logger.info("Updating Operation \"#{operation_id}\"")
      put("#{@api_url}/connections/#{connection_id}/operations/#{operation_id}", properties, headers)
    end

  end
end
