module KineticSdk
  class Core

    # Add a Web API on the Space
    #
    # @param body [Hash] hash of Web API properties
    #   - +method+ - The method of the Web API - "GET", "POST", "PUT", or "DELETE"
    #   - +slug+ - The slug of the Web API
    #   - +securityPolicies+ - [Array] Array of hashes
    #   -  - +endpoint+ - "Execution"
    #   -  - +name+ - Name of an existing Space Security Definition

    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_space_webapi(body, headers=default_headers)
      raise StandardError.new "Web API properties is not valid, must be a Hash." unless body.is_a? Hash
      @logger.info("Adding the \"#{body['slug']}\" to the Space.")
      post("#{@api_url}/webApis", body, headers)
    end
    
    # Add a Web API on a Kapp
    #
    # @param kapp_slug [String] the Kapp slug
    # @param body [Hash] hash of Web API properties
    #   - +method+ - The method of the Web API - "GET", "POST", "PUT", or "DELETE"
    #   - +slug+ - The slug of the Web API
    #   - +securityPolicies+ - [Array] Array of hashes
    #   -  - +endpoint+ - "Execution"
    #   -  - +name+ - Name of an existing Space Security Definition

    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_kapp_webapi(kapp_slug, body, headers=default_headers)
      raise StandardError.new "Web API properties is not valid, must be a Hash." unless body.is_a? Hash
      @logger.info("Adding the \"#{body['slug']}\" to the \"#{kapp_slug}\" Kapp.")
      post("#{@api_url}/kapps/#{kapp_slug}/webApis", body, headers)
    end
    
    # Find all Web APIs for the Space
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_space_webapis(params={}, headers=default_headers)
      @logger.info("Finding all Web APIs on the Space")
      get("#{@api_url}/webApis", params, headers)
    end
    
    # Find a single Web API on the Space
    #
    # @param slug [String] slug of the Web API
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_space_webapi(slug, params={}, headers=default_headers)
      @logger.info("Finding the \"#{slug}\" Web API on the Space")
      get("#{@api_url}/webApis/#{slug}", params, headers)
    end  
    
    # Find all Web APIs for a Kapp
    #
    # @param kapp_slug [String] the Kapp slug
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_webapis_on_kapp(kapp_slug, params={}, headers=default_headers)
      @logger.info("Finding all Web APIs on the \"#{kapp_slug}\" Kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}/webApis", params, headers)
    end    
    
    # Find a single Web API on the Kapp
    #
    # @param kapp_slug [String] the Kapp slug
    # @param slug [String] slug of the Web API
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_kapp_webapi(kapp_slug, slug, params={}, headers=default_headers)
      @logger.info("Finding the \"#{slug}\" Web API on the \"#{kapp_slug}\" Kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}/webApis/#{slug}", params, headers)
    end
    
    # Update a Web API on the Space
    #
    # All of the Web API properties are optional.  Only the properties provided
    # in the Hash will be updated, the other properties will retain their
    # current values.
    #
    # @param slug [String] the slug of the Web API
    # @param body [Hash] hash of Web API properties
    #   - +method+ - The method of the Web API - "GET", "POST", "PUT", or "DELETE"
    #   - +slug+ - The slug of the Web API
    #   - +securityPolicies+ - [Array] Array of hashes
    #   -  - +endpoint+ - "Execution"
    #   -  - +name+ - Name of an existing Space Security Definition
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_space_webapi(slug, body, headers=default_headers)
      @logger.info("Updating the \"#{slug}\" Web API on the Space.")
      put("#{@api_url}/webApis/#{slug}", body, headers)
    end
    
    # Update a Web API on a Kapp
    #
    # All of the Web API properties are optional.  Only the properties provided
    # in the Hash will be updated, the other properties will retain their
    # current values.
    #
    # @param kapp_slug [String] the Kapp slug
    # @param slug [String] the slug of the Web API
    # @param body [Hash] hash of Web API properties
    #   - +method+ - The method of the Web API - "GET", "POST", "PUT", or "DELETE"
    #   - +slug+ - The slug of the Web API
    #   - +securityPolicies+ - [Array] Array of hashes
    #   -  - +endpoint+ - "Execution"
    #   -  - +name+ - Name of an existing Space Security Definition
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_kapp_webapi(kapp_slug, slug, body, headers=default_headers)
      @logger.info("Updating the \"#{slug}\" Web API on the \"#{kapp_slug}\" Kapp.")
      put("#{@api_url}/kapps/#{kapp_slug}/webApis/#{slug}", body, headers)
    end
    
    # Delete a Web API on the Space
    # @param slug [String] the slug of the Web API
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_space_webapi(slug, headers=default_headers)
      @logger.info("Deleting the \"#{slug}\" Web API on the Space.")
      delete("#{@api_url}/webApis/#{slug}", headers)
    end
    
    # Delete a Web API on a Kapp
    # @param kapp_slug [String] the Kapp slug
    # @param slug [String] the slug of the Web API
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_kapp_webapi(kapp_slug, slug, headers=default_headers)
      @logger.info("Deleting the \"#{slug}\" Web API on the \"#{kapp_slug}\" Kapp.")
      delete("#{@api_url}/kapps/#{kapp_slug}/webApis/#{slug}", headers)
    end    
    
  end
end
