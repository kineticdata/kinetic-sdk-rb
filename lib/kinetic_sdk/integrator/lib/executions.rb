module KineticSdk
  class Integrator

    # Execute an Operation
    #
    # @param connection_id [String] id of the Connection
    # @param operation_id [String] id of the Operation
    # @param parameters [Hash] operation execution parameters
    # @param debug [boolean] execute in debug mode
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def execute_operation(connection_id, operation_id, parameters={}, debug=false, headers=default_jwt_headers)
      @logger.info("Executing operation #{operation_id}")
      payload = {
        "connection" => connection_id,
        "operation" => operation_id,
        "parameters" => parameters
      }
      url = "#{@api_url}/execute"
      url = "#{url}?debug=true" if debug
      post(url, payload, headers)
    end

    # Inspect an Operation
    #
    # @param operation_id [String] id of the Operation
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def inspect_operation(operation_id, headers=default_jwt_headers)
      @logger.info("Inspecting operation #{operation_id}")
      payload = {
        "operation" => operation_id
      }
      url = "#{@api_url}/inspect"
      post(url, payload, headers)
    end
  end
end
