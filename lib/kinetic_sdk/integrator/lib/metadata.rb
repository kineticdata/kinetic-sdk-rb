module KineticSdk
  class Integrator

    # Retrieve Integrator application version
    #
    # @param headers [Hash] hash of headers to send, default is accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def app_version(headers=header_accept_json)
      @logger.info("Retrieving Integrator version.")
      get("#{@api_url}/version", {}, headers)
    end

    # Check Integrator health
    #
    # @param headers [Hash] hash of headers to send, default is accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def health(headers=header_accept_json)
      @logger.info("Retrieving Integrator health.")
      get("#{@api_url}/healthz", {}, headers)
    end

    # OpenApi Specification
    #
    # @param headers [Hash] hash of headers to send, default is accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def oas(headers=header_accept_json)
      @logger.info("Retrieving OpenAPI Specification.")
      get("#{@api_url}/oas", {}, headers)
    end
  end
end
