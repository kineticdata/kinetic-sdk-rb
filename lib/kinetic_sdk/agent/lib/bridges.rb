module KineticSdk
  class Agent

    # Add Bridge
    #
    # @param space [String] slug of the space
    # @param body [Hash] properties associated to the Bridge
    #   - +adapterClass+
    #   - +name+
    #   - +slug+
    #   - +properties+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_bridge(space, body, headers=default_headers)
      @logger.info("Adding the \"#{body['name']}\" bridge in the \"#{space}\" space.")
      post("#{@api_url}/spaces/#{space}/bridges", body, headers)
    end

    # Delete a Bridge
    #
    # @param space [String] slug of the space
    # @param slug [String] slug of the Bridge
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_bridge(space, slug, headers=default_headers)
      @logger.info("Deleting the \"#{slug}\" bridge in the \"#{space}\" space.")
      delete("#{@api_url}/spaces/#{space}/bridges/#{slug}", headers)
    end

    # Find a bridge
    #
    # @param space [String] slug of the space
    # @param slug [String] slug of the bridge
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_bridge(space, slug, params={}, headers=default_headers)
      @logger.info("Finding the \"#{slug}\" bridge in the \"#{space}\" space.")
      get("#{@api_url}/spaces/#{space}/bridges/#{slug}", params, headers)
    end

    # Update a bridge
    #
    # @param space [String] slug of the space
    # @param slug [String] slug of the bridge
    # @param body [Hash] properties of the bridge to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_bridge(space, slug, body={}, headers=default_headers)
      @logger.info("Updating the \"#{slug}\" bridge in the \"#{space}\" space.")
      put("#{@api_url}/spaces/#{space}/bridges/#{slug}", body, headers)
    end

    # Find all bridges in a space
    #
    # @param space [String] slug of the space
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_bridges(space, params={}, headers=default_headers)
      @logger.info("Find all bridges in the \"#{space}\" space.")
      get("#{@api_url}/spaces/#{space}/bridges", params, headers)
    end

    # Add Bridge to Space
    #
    # @param space [String] slug of the space
    # @param body [Hash] properties associated to the Bridge
    #   - +space+
    #   - +adapterClass+
    #   - +name+
    #   - +slug+
    #   - +properties+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_space_bridge(body, headers=default_headers)
      @logger.info("Adding the \"#{body['name']}\" bridge in the \"#{body['space']}\" space.")
      post("#{@api_url}/bridges", body, headers)
    end

    # Find all bridges in the system
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_all_bridges(params={}, headers=default_headers)
      @logger.info("Find all bridges.")
      get("#{@api_url}/bridges", params, headers)
    end

  end
end
