module KineticSdk
  class Core

    # Add a Bridge
    #
    # @param body [Hash] properties associated to the Bridge
    #   - +adapterClass+
    #   - +name+
    #   - +slug+
    #   - +properties+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_bridge(body, headers=default_headers)
      @logger.info("Adding the \"#{body['name']}\" bridge through proxy to the agent platform component.")
      post("#{@proxy_url}/agent/app/api/v1/bridges", body, headers)
    end

    # Delete a Bridge
    #
    # @param slug [String] slug of the Bridge
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_bridge(slug, headers=default_headers)
      @logger.info("Deleting the \"#{slug}\" bridge through proxy to the agent platform component.")
      delete("#{@proxy_url}/agent/app/api/v1/bridges/#{slug}", headers)
    end

    # Find a list of bridges
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_bridges(params={}, headers=default_headers)
      @logger.info("Find bridges through proxy to the agent platform component.")
      get("#{@proxy_url}/agent/app/api/v1/bridges", params, headers)
    end

    # Find a bridge
    #
    # @param slug [String] slug of the bridge
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_bridge(slug, params={}, headers=default_headers)
      @logger.info("Finding the \"#{slug}\" bridge through proxy to the agent platform component.")
      get("#{@proxy_url}/agent/app/api/v1/bridges/#{slug}", params, headers)
    end

    # Update a bridge
    #
    # @param slug [String] slug of the bridge
    # @param body [Hash] properties of the bridge to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_bridge(slug, body={}, headers=default_headers)
      @logger.info("Updating the \"#{slug}\" bridge through proxy to the agent platform component.")
      put("#{@proxy_url}/agent/app/api/v1/bridges/#{slug}", body, headers)
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
      @logger.info("Adding the \"#{body['name']}\" Bridge Model and Mappings.")
      post("#{@api_url}/models", body, headers)
    end

    # Delete a Bridge Model
    #
    # @param name [String] name of the Bridge Model
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_bridge_model(name, headers=default_headers)
      @logger.info("Deleting the \"#{name}\" Bridge Model.")
      delete("#{@api_url}/models/#{encode(name)}", headers)
    end

    # Find a list of bridge models
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_bridge_models(params={}, headers=default_headers)
      @logger.info("Find Bridge models.")
      get("#{@api_url}/models", params, headers)
    end

    # Find a bridge model
    #
    # @param name [String] name of the bridge model
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_bridge_model(name, params={}, headers=default_headers)
      @logger.info("Finding the \"#{name}\" Bridge Model.")
      get("#{@api_url}/models/#{encode(name)}", params, headers)
    end

    # Update a Bridge Model
    #
    # @param name [String] name of the bridge model
    # @param body [Hash] optional properties associated to the Bridge Model
    #   - +name+
    #   - +status+
    #   - +activeMappingName+
    #   - +attributes+
    #   - +mappings+
    #   - +qualifications+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_bridge_model(name, body={}, headers=default_headers)
      @logger.info("Updating the \"#{name}\" Bridge Model.")
      put("#{@api_url}/models/#{encode(name)}", body, headers)
    end

    # Update a Bridge Model Mapping
    #
    # @param model_name [String] name of the bridge model
    # @param mapping_name [String] name of the bridge model mapping
    # @param body [Hash] optional properties associated to the Bridge Model Mapping
    #   - +name+
    #   - +bridgeSlug+
    #   - +structure+
    #   - +attributes+
    #   - +qualifications+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_bridge_model_mapping(model_name, mapping_name, body={}, headers=default_headers)
      @logger.info("Updating the \"#{model_name} - #{mapping_name}\" Bridge Model Mapping.")
      put("#{@api_url}/models/#{encode(model_name)}/mappings/#{encode(mapping_name)}", body, headers)
    end
  end
end
