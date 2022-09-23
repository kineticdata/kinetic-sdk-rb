module KineticSdk
  class Core

    # Add a Kapp
    #
    # @param kapp_name [String] name of the Kapp
    # @param kapp_slug [String] slug of the Kapp
    # @param properties [Hash] optional properties associated to the Kapp
    #   - +afterLogoutPath+
    #   - +bundlePath+
    #   - +defaultFormDisplayPage+
    #   - +defaultFormConfirmationPage+
    #   - +defaultSubmissionLabelExpression+
    #   - +displayType+
    #   - +displayValue+
    #   - +loginPage+
    #   - +resetPasswordPage+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_kapp(kapp_name, kapp_slug, properties={}, headers=default_headers)
      properties.merge!({
        "name" => kapp_name,
        "slug" => kapp_slug
      })
      @logger.info("Adding the \"#{kapp_name}\" Kapp.")
      post("#{@api_url}/kapps", properties, headers)
    end

    # Delete a Kapp
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_kapp(kapp_slug, headers=default_headers)
      @logger.info("Deleting the \"#{kapp_slug}\" Kapp.")
      delete("#{@api_url}/kapps/#{kapp_slug}", headers)
    end

    # Exports a Kapp
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def export_kapp(kapp_slug, headers=default_headers)
      @logger.info("Exporting the \"#{kapp_slug}\" Kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}", { 'export' => true }, headers)
    end

    # Find Kapps
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_kapps(params={}, headers=default_headers)
      @logger.info("Finding Kapps.")
      get("#{@api_url}/kapps", params, headers)
    end

    # Find a Kapp
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_kapp(kapp_slug, params={}, headers=default_headers)
      @logger.info("Finding Kapp \"#{kapp_slug}\"")
      get("#{@api_url}/kapps/#{kapp_slug}", params, headers)
    end

    # Update a Kapp
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param properties [Hash] optional properties associated to the Kapp
    #   - +afterLogoutPath+
    #   - +bundlePath+
    #   - +defaultFormDisplayPage+
    #   - +defaultFormConfirmationPage+
    #   - +defaultSubmissionLabelExpression+
    #   - +displayType+
    #   - +displayValue+
    #   - +loginPage+
    #   - +name+
    #   - +resetPasswordPage+
    #   - +slug+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_kapp(kapp_slug, properties={}, headers=default_headers)
      @logger.info("Updating the \"#{kapp_slug}\" Kapp.")
      put("#{@api_url}/kapps/#{kapp_slug}", properties, headers)
    end


    # Find Kapp workflows
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_kapp_workflows(kapp_slug, params={}, headers=default_headers)
      @logger.info("Find workflows in the \"#{kapp_slug}\" Kapp")
      get("#{@api_url}/kapps/#{kapp_slug}/workflows", params, headers)
    end


    # Find a kapp workflow
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param workflow_id [UUID] the workflow UUID
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_kapp_workflow(kapp_slug, workflow_id, params={}, headers=default_headers)
      @logger.info("Find workflow #{workflow_id} in the \"#{kapp_slug}\" Kapp")
      get("#{@api_url}/kapps/#{kapp_slug}/workflows/#{workflow_id}", params, headers)
    end


    # Add Kapp workflow
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param payload [Hash] hash of required workflow properties
    #   - +event+
    #   - +name+
    #   - +treeXml+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_kapp_workflow(kapp_slug, payload, headers=default_headers)
      @logger.info("Add workflow to the \"#{kapp_slug}\" Kapp.")
      post("#{@api_url}/kapps/#{kapp_slug}/workflows", payload, headers)
    end


    # Delete Kapp workflow
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param workflow_id [UUID] the workflow UUID
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_kapp_workflow(kapp_slug, workflow_id, headers=default_headers)
      @logger.info("Delete workflow from the \"#{kapp_slug}\" Kapp.")
      delete("#{@api_url}/kapps/#{kapp_slug}/workflows/#{workflow_id}", headers)
    end

  end
end
