module KineticSdk
  class Core

    # Add a form type on a Kapp
    # The method is being depreciated and replaced with add_formtype
    #
    # @param kapp_slug [String] slug of the Kapp the form type belongs to
    # @param body [Hash] form type properties
    #   - +name+ - A descriptive name for the form type
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_form_type_on_kapp(kapp_slug, body, headers=default_headers)
      raise StandardError.new "Form Type properties is not valid, must be a Hash." unless body.is_a? Hash
      @logger.info("Adding Form Type \"#{body['name']}\" for \"#{kapp_slug}\" kapp")
      post("#{@api_url}/kapps/#{kapp_slug}/formTypes", body, headers)
    end

    alias :add_formtype :add_form_type_on_kapp

    def add_form_type_on_kapp(kapp_slug, body, headers=default_headers)
      @logger.info "Deprecation Warning: add_form_type_on_kapp method will be removed in a future version. Please use #add_formtype"
      add_formtype(kapp_slug, body, headers=default_headers)
    end
    
    
    # Update a form type on a Kapp
    #
    # @param kapp_slug [String] slug of the Kapp the form type belongs to
    # @param name [String] name of the form type
    # @param body [Hash] form type properties
    #   - +name+ - A descriptive name for the form type
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_formtype(kapp_slug, name, body, headers=default_headers)
      raise StandardError.new "Form Type properties is not valid, must be a Hash." unless body.is_a? Hash
      @logger.info("Updating Form Type \"#{body['name']}\" for \"#{kapp_slug}\" kapp")
      put("#{@api_url}/kapps/#{kapp_slug}/formTypes/#{encode(name)}", body, headers)
    end

    # Delete a form type on a Kapp
    # The method is being depreciated and replaced with delete_formtype    
    #
    # @param kapp_slug [String] slug of the Kapp the form type belongs to
    # @param name [String] name of the form type
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_form_type(kapp_slug, name, headers=default_headers)
      @logger.info("Deleting form type \"#{name}\" from \"#{kapp_slug}\" kapp")
      delete("#{@api_url}/kapps/#{kapp_slug}/formTypes/#{encode(name)}", headers)
    end
    
    alias :delete_formtype :delete_form_type

    def delete_form_type(kapp_slug, name, headers=default_headers)
      @logger.info "Deprecation Warning: delete_form_type method will be removed in a future version. Please use #delete_formtype"
      delete_formtype(kapp_slug, name, headers=default_headers)
    end

    # Delete all form types on a Kapp
    # The method is being depreciated and replaced with delete_formtypes
    #
    # @param kapp_slug [String] slug of the Kapp the form types belongs to
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_form_types_on_kapp(kapp_slug, headers=default_headers)
      (find_formtypes(kapp_slug, {}, headers).content["formTypes"] || []).each do |form_type|
        delete_formtype(kapp_slug, form_type['name'], headers)
      end
    end
    
    alias :delete_formtypes :delete_form_types_on_kapp

    def delete_form_types_on_kapp(kapp_slug, headers=default_headers)
      @logger.info "Deprecation Warning: delete_form_types_on_kapp method will be removed in a future version. Please use #delete_formtypes"
      delete_formtypes(kapp_slug, headers=default_headers)
    end

    # Retrieve a single form types for a Kapp
    #
    # @param kapp_slug [String] slug of the Kapp the form types belongs to
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_formtype(kapp_slug, name, params={}, headers=default_headers)
      @logger.info("Finding the #{name}Form Type for \"#{kapp_slug}\" kapp")
      get("#{@api_url}/kapps/#{kapp_slug}/formTypes/#{encode(name)}", params, headers)
    end

    # Retrieve a list of all form types for a Kapp
    # The method is being depreciated and replaced with find_formtypes
    #
    # @param kapp_slug [String] slug of the Kapp the form types belongs to
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_form_types_on_kapp(kapp_slug, params={}, headers=default_headers)
      @logger.info("Finding Form Types for \"#{kapp_slug}\" kapp")
      get("#{@api_url}/kapps/#{kapp_slug}/formTypes", params, headers)
    end
    
    alias :find_formtypes :find_form_types_on_kapp

    def find_form_types_on_kapp(kapp_slug, params={}, headers=default_headers)
      @logger.info "Deprecation Warning: find_form_types_on_kapp method will be removed in a future version. Please use #find_formtypes"
      find_formtypes(kapp_slug, params={}, headers=default_headers)
    end
  end
end
