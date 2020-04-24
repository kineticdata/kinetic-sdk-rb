module KineticSdk
  class Core

    # Retrieve a Category on a Kapp
    #
    # @param kapp_slug [String] slug of the Kapp the category belongs to
    # @param category_slug [String] slug of the the category to find
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_category_on_kapp(kapp_slug, category_slug, params={}, headers=default_headers)
      @logger.info("Finding #{category_slug} Category on the #{kapp_slug} kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}/categories/#{category_slug}", params, headers)
    end

    # Find Categories on a Kapp
    #
    # @param kapp_slug [String] slug of the Kapp the category belongs to
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_categories(kapp_slug, params={}, headers=default_headers)
      @logger.info("Finding Categories on the #{kapp_slug} kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}/categories", params, headers)
    end
    
    # Add a category on a Kapp
    #
    # @param kapp_slug [String] slug of the Kapp the category belongs to
    # @param body [Hash] category properties
    #   - +name+ - A descriptive name for the category
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_category_on_kapp(kapp_slug, body, headers=default_headers)
      raise StandardError.new "Category properties is not valid, must be a Hash." unless body.is_a? Hash
      @logger.info("Adding Category \"#{body['name']}\" for \"#{kapp_slug}\" kapp")
      post("#{@api_url}/kapps/#{kapp_slug}/categories", body, headers)
    end

    # Add a categorization on a form
    #
    # @param kapp_slug [String] slug of the Kapp the category belongs to
    # @param body [Hash] categorization properties
    #   - +category+ - A hash of properties for the category
    #   - +category/slug+ - The slug of the category to apply to the form
    #   - +form+ - A hash of properties for the form
    #   - +form/slug+ - The slug of the form to apply the category
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_categorization_on_form(kapp_slug, body, headers=default_headers)
      raise StandardError.new "Category properties is not valid, must be a Hash." unless body.is_a? Hash
      @logger.info("Adding Categorization for \"#{kapp_slug}\" kapp")
      post("#{@api_url}/kapps/#{kapp_slug}/categorizations", body, headers)
    end
    
    # Update a category on a Kapp
    #
    # @param kapp_slug [String] slug of the Kapp the category belongs to
    # @param category_slug [String] slug of the the category to find    
    # @param body [Hash] category properties
    #   - +name+ - A descriptive name for the category
    #   - +other details + -     
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_category_on_kapp(kapp_slug, category_slug, body, headers=default_headers)
      raise StandardError.new "Category properties is not valid, must be a Hash." unless body.is_a? Hash
      @logger.info("Updating Category \"#{body['name']}\" for \"#{kapp_slug}\" kapp")
      put("#{@api_url}/kapps/#{kapp_slug}/categories/#{category_slug}", body, headers)
    end
    
    # Delete a Category
    #
    # @param kapp_slug [String] slug of the Kapp the category belongs to
    # @param category_slug [String] slug of the the category to delete    
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_category_on_kapp(kapp_slug, category_slug, headers=default_headers)
      @logger.info("Deleting the #{category_slug} Category on the #{kapp_slug}\ kapp.")
      delete("#{@api_url}/kapps/#{kapp_slug}/categories/#{category_slug}", headers)
    end

  end
end
