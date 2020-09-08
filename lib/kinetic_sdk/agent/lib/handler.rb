module KineticSdk
  class Agent

    # Add Handler
    #
    # @param space [String] slug of the space
    # @param body [Hash] properties associated to the Handler
    #   - +adapterClass+
    #   - +name+
    #   - +slug+
    #   - +properties+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_handler(space, body, headers=default_headers)
      @logger.info("Adding the \"#{body['name']}\" handler in the \"#{space}\" space.")
      post("#{@api_url}/spaces/#{space}/handlers", body, headers)
    end

    # Delete a Handler
    #
    # @param space [String] slug of the space
    # @param slug [String] slug of the Handler
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_handler(space, slug, headers=default_headers)
      @logger.info("Deleting the \"#{slug}\" handler in the \"#{space}\" space.")
      delete("#{@api_url}/spaces/#{space}/handlers/#{slug}", headers)
    end

    # Find a handler
    #
    # @param space [String] slug of the space
    # @param slug [String] slug of the handler
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_handler(space, slug, params={}, headers=default_headers)
      @logger.info("Finding the \"#{slug}\" handler in the \"#{space}\" space.")
      get("#{@api_url}/spaces/#{space}/handlers/#{slug}", params, headers)
    end

    # Update a handler
    #
    # @param space [String] slug of the space
    # @param slug [String] slug of the handler
    # @param body [Hash] properties of the handler to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_handler(space, slug, body={}, headers=default_headers)
      @logger.info("Updating the \"#{slug}\" handler in the \"#{space}\" space.")
      put("#{@api_url}/spaces/#{space}/handlers/#{slug}", body, headers)
    end

    # Find all handlers in a space
    #
    # @param space [String] slug of the space
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_handlers(space, params={}, headers=default_headers)
      @logger.info("Find all handlers in the \"#{space}\" space.")
      get("#{@api_url}/spaces/#{space}/handlers", params, headers)
    end

    # Add Handler to Space
    #
    # @param body [Hash] properties associated to the Handler
    #   - +space+
    #   - +definitionId+
    #   - +slug+
    #   - +properties+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_space_handler(body, headers=default_headers)
      @logger.info("Adding the \"#{body['name']}\" handler in the \"#{body['space']}\" space.")
      post("#{@api_url}/handlers", body, headers)
    end

    # Find all handlers in the system
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_all_handlers(params={}, headers=default_headers)
      @logger.info("Find all handlers.")
      get("#{@api_url}/handlers", params, headers)
    end

  end
end
