module KineticSdk
  class Agent

    # Add Filestore
    #
    # @param space [String] slug of the space
    # @param body [Hash] properties associated to the Filestore
    #   - +adapterClass+
    #   - +name+
    #   - +slug+
    #   - +properties+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_filestore(space, body, headers=default_headers)
      @logger.info("Adding the \"#{body['name']}\" filestore in the \"#{space}\" space.")
      post("#{@api_url}/spaces/#{space}/filestores", body, headers)
    end

    # Delete a Filestore
    #
    # @param space [String] slug of the space
    # @param slug [String] slug of the Filestore
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_filestore(space, slug, headers=default_headers)
      @logger.info("Deleting the \"#{slug}\" filestore in the \"#{space}\" space.")
      delete("#{@api_url}/spaces/#{space}/filestores/#{slug}", headers)
    end

    # Find a filestore
    #
    # @param space [String] slug of the space
    # @param slug [String] slug of the filestore
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_filestore(space, slug, params={}, headers=default_headers)
      @logger.info("Finding the \"#{slug}\" filestore in the \"#{space}\" space.")
      get("#{@api_url}/spaces/#{space}/filestores/#{slug}", params, headers)
    end

    # Update a filestore
    #
    # @param space [String] slug of the space
    # @param slug [String] slug of the filestore
    # @param body [Hash] properties of the filestore to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_filestore(space, slug, body={}, headers=default_headers)
      @logger.info("Updating the \"#{slug}\" filestore in the \"#{space}\" space.")
      put("#{@api_url}/spaces/#{space}/filestores/#{slug}", body, headers)
    end

    # Find all filestores in a space
    #
    # @param space [String] slug of the space
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_filestores(space, params={}, headers=default_headers)
      @logger.info("Find all filestores in the \"#{space}\" space.")
      get("#{@api_url}/spaces/#{space}/filestores", params, headers)
    end

    # Add Filestore to Space
    #
    # @param body [Hash] properties associated to the Filestore
    #   - +space+
    #   - +adapterClass+
    #   - +slug+
    #   - +properties+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_space_filestore(body, headers=default_headers)
      @logger.info("Adding the \"#{body['name']}\" filestore in the \"#{body['space']}\" space.")
      post("#{@api_url}/filestores", body, headers)
    end

    # Find all filestores in the system
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_all_filestores(params={}, headers=default_headers)
      @logger.info("Find all filestores.")
      get("#{@api_url}/filestores", params, headers)
    end

  end
end
