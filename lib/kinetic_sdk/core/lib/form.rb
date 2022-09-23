module KineticSdk
  class Core

    # Add a Form
    #
    # @param kapp_slug [String] slug of the Kapp the form belongs to
    # @param form_properties [Hash] form properties
    #   - +anonymous+
    #   - +customHeadContent+
    #   - +description+
    #   - +name+
    #   - +notes+
    #   - +slug+
    #   - +status+
    #   - +submissionLabelExpression+
    #   - +type+
    #   - +attributes+
    #   - +bridgedResources+
    #   - +pages+
    #   - +securityPolicies+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_form(kapp_slug, form_properties={}, headers=default_headers)
      @logger.info("Adding the \"#{form_properties['name']}\" Form.")
      post("#{@api_url}/kapps/#{kapp_slug}/forms", form_properties, headers)
    end

    # Delete a Form
    #
    # @param kapp_slug [String] slug of the Kapp the form belongs to
    # @param form_slug [String] slug of the form
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_form(kapp_slug, form_slug, headers=default_headers)
      @logger.info("Deleting the \"#{form_slug}\" Form in the \"#{kapp_slug}\" Kapp.")
      delete("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}", headers)
    end

    # Export a Form
    #
    # @param kapp_slug [String] slug of the Kapp the form belongs to
    # @param form_slug [String] slug of the form
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def export_form(kapp_slug, form_slug, headers=default_headers)
      @logger.info("Exporting the \"#{form_slug}\" Form in the \"#{kapp_slug}\" Kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}", { 'export' => true }, headers)
    end

    # Find Forms
    #
    # @param kapp_slug [String] slug of the Kapp the forms belongs to
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_forms(kapp_slug, params={}, headers=default_headers)
      @logger.info("Finding Forms.")
      get("#{@api_url}/kapps/#{kapp_slug}/forms", params, headers)
    end

    # Find a Form
    #
    # @param kapp_slug [String] slug of the Kapp the form belongs to
    # @param form_slug [String] slug of the form
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_form(kapp_slug, form_slug, params={}, headers=default_headers)
      @logger.info("Finding the \"#{form_slug}\" Form in the \"#{kapp_slug}\" Kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}", params, headers)
    end

    # Update a Form
    #
    # @param kapp_slug [String] slug of the Kapp the form belongs to
    # @param form_slug [String] slug of the form
    # @param properties [Hash] form properties to update
    #   - +anonymous+
    #   - +customHeadContent+
    #   - +description+
    #   - +name+
    #   - +notes+
    #   - +slug+
    #   - +status+
    #   - +submissionLabelExpression+
    #   - +type+
    #   - +attributes+
    #   - +bridgedResources+
    #   - +pages+
    #   - +securityPolicies+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_form(kapp_slug, form_slug, properties={}, headers=default_headers)
      @logger.info("Updating the \"#{form_slug}\" Form in the \"#{kapp_slug}\" Kapp.")
      put("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}", properties, headers)
    end


    # Find Form workflows
    #
    # @param kapp_slug [String] slug of the Kapp the form belongs to
    # @param form_slug [String] slug of the form
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_form_workflows(kapp_slug, form_slug, params={}, headers=default_headers)
      @logger.info("Find workflows in the \"#{form_slug}\" Form in the \"#{kapp_slug}\" Kapp")
      get("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}/workflows", params, headers)
    end
    

    # Find a form workflow
    #
    # @param kapp_slug [String] slug of the Kapp the form belongs to
    # @param form_slug [String] slug of the form
    # @param workflow_id [UUID] the workflow UUID
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_form_workflow(kapp_slug, form_slug, workflow_id, params={}, headers=default_headers)
      @logger.info("Find workflow #{workflow_id} in the \"#{form_slug}\" Form in the \"#{kapp_slug}\" Kapp")
      get("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}/workflows/#{workflow_id}", params, headers)
    end


    # Add Form workflow
    #
    # @param kapp_slug [String] slug of the Kapp the form belongs to
    # @param form_slug [String] slug of the form
    # @param payload [Hash] hash of required workflow properties
    #   - +event+
    #   - +name+
    #   - +treeXml+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_form_workflow(kapp_slug, form_slug, payload, headers=default_headers)
      @logger.info("Add workflow to the \"#{form_slug}\" Form in the \"#{kapp_slug}\" Kapp.")
      post("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}/workflows", payload, headers)
    end

    # Delete Kapp workflow
    #
    # @param kapp_slug [String] slug of the Kapp the form belongs to
    # @param form_slug [String] slug of the form
    # @param workflow_id [UUID] the workflow UUID
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_form_workflow(kapp_slug, form_slug, workflow_id, headers=default_headers)
      @logger.info("Delete workflow from the \"#{form_slug}\" Form in the \"#{kapp_slug}\" Kapp.")
      delete("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}/workflows/#{workflow_id}", headers)
    end

  end
end
