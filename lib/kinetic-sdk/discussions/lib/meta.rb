module KineticSdk
  class Discussions

    # Retrieve Discussions application version
    #
    # @param headers [Hash] hash of headers to send, default is accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def app_version(headers=header_accept_json)
      info("Retrieving Discussions application version.")
      get("#{@api_url}/version", {}, headers)
    end

  end
end
