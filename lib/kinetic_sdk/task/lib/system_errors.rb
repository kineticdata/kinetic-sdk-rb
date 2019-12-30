module KineticSdk
  class Task

    # Delete a system error
    #
    # @param id [Integer] id of the system error
    # @param headers [Hash] headers to send with the request, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_system_error(id, headers=header_basic_auth)
      @logger.info("Deleting system error \"#{id}\"")
      delete("#{@api_url}/systemErrors/#{id}", headers)
    end

    # Resolve multiple system errors with the same resolution notes.
    #
    # @param ids [Array<Integer>] Array of system error ids to resolve
    # @param resolution [String] resolution notes
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def resolve_system_errors(ids, resolution, headers=default_headers)
      @logger.info("Resolving system errors #{ids}")
      body = { "ids" => ids, "resolution" => resolution }
      post("#{@api_url}/systemErrors/resolve", body, headers)
    end

    # Find a list of system errors.
    #
    # @param params [Hash] Query parameters that are added to the URL
    #   - +timeline+ - either "createdAt" or "updatedAt". Default: createdAt
    #   - +direction+ - DESC or ASC (default: DESC)
    #   - +start+ - 2017-07-27 or 2017-07-27T15:00:00.000Z
    #   - +end+ - 2017-07-27 or 2017-07-27T15:00:00.000Z
    #   - +type+
    #   - +status+
    #   - +relatedItem1Id+
    #   - +relatedItem1Type+
    #   - +relatedItem2Id+
    #   - +relatedItem2Type+
    #   - +limit+
    #   - +offset+
    #   - +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_system_errors(params={}, headers=header_basic_auth)
      @logger.info("Finding system errors")
      get("#{@api_url}/systemErrors", params, headers)
    end

    # Find a system error
    #
    # @param id [Integer] id of the system error
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_system_error(id, params={}, headers=header_basic_auth)
      @logger.info("Finding system error #{id}")
      get("#{@api_url}/systemErrors/#{id}", params, headers)
    end

  end
end
