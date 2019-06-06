module KineticSdk
  class Core

    # Retrieve Core application version
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def app_version(headers=default_headers)
      info("Retrieving Core application version.")
      get("#{@api_url}/version", {}, headers)
    end

  end
end
