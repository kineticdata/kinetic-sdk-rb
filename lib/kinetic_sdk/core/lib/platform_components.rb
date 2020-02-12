require "digest/md5"

module KineticSdk
  class Core

    # Find Task Component
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_task_component(params = {}, headers = default_headers)
      @logger.info("Finding Task Component.")
      get("#{@api_url}/platformComponents/task", params, headers)
    end

    # Update Task Component
    #
    # @param component_properties [Hash] the property values for the platform component
    #   - +url+ - Url to the task component
    #   - +secret+ - Shared secret used to encrypt traffic between core component and task component
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_task_component(component_properties, headers = default_headers)
      raise StandardError.new "Task Component properties is not valid, must be a Hash." unless component_properties.is_a? Hash
      @logger.info("Updating Task Platform Component")
      put("#{@api_url}/platformComponents/task", component_properties, headers)
    end

    # Find Agent Component
    #
    # @param agent_slug [String] the slug of the agent to retrieve
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_agent_component(agent_slug, params = {}, headers = default_headers)
      @logger.info("Finding Agent Component with slug: \"#{agent_slug}\".")
      get("#{@api_url}/platformComponents/agents/#{agent_slug}", params, headers)
    end

    # Find Agent Components
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_agent_components(params = {}, headers = default_headers)
      @logger.info("Finding Agent Components.")
      get("#{@api_url}/platformComponents/agents", params, headers)
    end

    # Add Agent Component
    #
    # @param component_properties [Hash] the property values for the team
    #   - +slug+ - Slug of the agent to be added
    #   - +url+ -  URL for the agent being added
    #   - +secret+ - Secret for the agent being added
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_agent_component(component_properties, headers = default_headers)
      raise StandardError.new "Agent Component properties is not valid, must be a Hash." unless component_properties.is_a? Hash
      @logger.info("Creating Agent Component \"#{component_properties["slug"]}\".")
      post("#{@api_url}/platformComponents/agents", component_properties, headers)
    end

    # Update Agent Component
    #
    # @param agent_slug [String] the slug of the agent to update
    # @param component_properties [Hash] the property values for the team
    #   - +slug+ - Slug of the agent to be added
    #   - +url+ -  URL for the agent being added
    #   - +secret+ - Secret for the agent being added
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_agent_component(agent_slug, component_properties, headers = default_headers)
      raise StandardError.new "Agent Component properties is not valid, must be a Hash." unless component_properties.is_a? Hash
      @logger.info("Updating Agent Component \"#{agent_slug}\".")
      put("#{@api_url}/platformComponents/agents/#{agent_slug}", component_properties, headers)
    end

    # Delete Agent Component
    #
    # @param agent_slug [String] the slug of the agent to retrieve
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_agent_component(agent_slug, headers = default_headers)
      @logger.info("Deleting Agent Component with slug: \"#{agent_slug}\".")
      delete("#{@api_url}/platformComponents/agents/#{agent_slug}", headers)
    end
  end
end
