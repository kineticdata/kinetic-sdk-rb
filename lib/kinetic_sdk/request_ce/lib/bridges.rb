module KineticSdk
  class RequestCe

    # Add a Bridge
    #
    # @param body [Hash] optional properties associated to the Bridge
    #   - +name+
    #   - +status+
    #   - +url+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_bridge(body={}, headers=default_headers)
      info("Adding the \"#{body['name']}\" Bridge.")
      post("#{@api_url}/bridges", body, headers)
    end
    
    # Delete a Bridge
    #
    # @param name [String] name of the Bridge
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_bridge(name, headers=default_headers)
      info("Deleting the \"#{encode(name)}\" Bridge.")
      delete("#{@api_url}/bridges/#{encode(name)}", headers)
    end

    # Delete a Bridge Model
    #
    # @param name [String] name of the Bridge Model
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_bridge_model(name, headers=default_headers)
      info("Deleting the \"#{encode(name)}\" Bridge Model.")
      delete("#{@api_url}/models/#{encode(name)}", headers)
    end

    # Add a Bridge Model
    #
    # @param body [Hash] optional properties associated to the Bridge Model
    #   - +name+
    #   - +status+
    #   - +activeMappingName+
    #   - +attributes+
    #   - +mappings+
    #   - +qualifications+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_bridge_model(body={}, headers=default_headers)
      info("Adding the \"#{body['name']}\" Bridge Model and Mappings.")
      post("#{@api_url}/models", body, headers)
    end

    # Find a list of bridges
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_bridges(params={}, headers=default_headers)
      info("Bridges.")
      get("#{@api_url}/bridges", params, headers)
    end

    # Find a bridge
    #
    # @param name [String] name of the bridge
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_bridge(name, params={}, headers=default_headers)
      info("Finding the \"#{name}\" Bridge.")
      get("#{@api_url}/bridges/#{encode{name}}", params, headers)
    end

    # Find a list of bridge models
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_bridge_models(params={}, headers=default_headers)
      info("Models.")
      get("#{@api_url}/models", params, headers)
    end
    
    # Update a bridge
    #
    # @param name [String] name of the bridge
    # @param body [Hash] properties of the bridge to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_bridge(name, body={}, headers=default_headers)
      info("Updating the \"#{name}\" Bridge.")
      put("#{@api_url}/bridges/#{encode(name)}", body, headers)
    end

  end
end
