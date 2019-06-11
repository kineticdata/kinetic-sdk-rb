module KineticSdk
  class Core

    # Add an attribute value to the space, or update an attribute if it already exists
    #
    # @param attribute_name [String] name of the attribute
    # @param attribute_value [String] value of the attribute
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_space_attribute(attribute_name, attribute_value, headers=default_headers)
      # first find the space
      response = find_space({ "include" => "attributes"}, headers)
      # hack to try a second time if space isn't found
      if response.status == 404
        sleep 2
        response = find_space({ "include" => "attributes"}, headers)
      end
      space = response.content["space"]
      attributes = space["attributes"]
      # either add or update the attribute value
      exists = false
      attributes.each do |attribute|
        info("Attribute: #{attribute.inspect}")
        # if the attribute already exists, update it
        if attribute["name"] == attribute_name
          attribute["values"] = [ attribute_value ]
          exists = true
        end
      end
      # add the attribute if it didn't exist
      attributes.push({
        "name" => attribute_name,
        "values" => [ attribute_value ]
        }) unless exists

      # set the updated attributes list
      body = { "attributes" => attributes }
      if exists
        info("Updating attribute \"#{attribute_name}\" = \"#{attribute_value}\" in the \"#{space_slug}\" space.")
      else
        info("Adding attribute \"#{attribute_name}\" = \"#{attribute_value}\" to the \"#{space_slug}\" space.")
      end
      # Update the space
      put("#{@api_url}/space", body, headers)
    end

    # Update a space
    #
    # @param body [Hash] properties for the Space
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_space(body={}, headers=default_headers)
      info("Updating Space \"#{@space_slug}\"")
      put("#{@api_url}/space", body, headers)
    end

    # Export a space to the export_directory
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return nil
    def export_space(headers=default_headers)
      raise StandardError.new "An export directory must be defined to export space." if @options[:export_directory].nil?
      info("Exporting space definition to #{@options[:export_directory]}.")
      # Build up the tree of how files should be written
      export_shape = prepare_shape(
        "space.bridges.{name}",
        "space.datastore.forms.{slug}",
        "space.kapps.{slug}.categories",
        "space.kapps.{slug}.categoryAttributeDefinitions",
        "space.kapps.{slug}.forms.{slug}",
        "space.kapps.{slug}.formAttributeDefinitions",
        "space.kapps.{slug}.formsTypes",
        "space.kapps.{slug}.kappAttributeDefinitions",
        "space.kapps.{slug}.securityPolicyDefinitions",
        "space.models.{name}",
        "space.teams.{name}",
        "space.datastoreFormAttributeDefinitions",
        "space.securityPolicyDefinitions",
        "space.spaceAttributeDefinitions",
        "space.teamAttributeDefinitions",
        "space.userAttributeDefinitions",
        "space.userProfileAttributeDefinitions",
        "space.webhooks",
      )
      core_data = get("#{@api_url}/space", { 'export' => true}, headers).content
      process_export(@options[:export_directory], export_shape, core_data)
      info("Finished exporting space definition to #{@options[:export_directory]}.")
    end

    # Find the space
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_space(params={}, headers=default_headers)
      info("Finding Space \"#{@space_slug}\"")
      get("#{@api_url}/space", params, headers)
    end

    # Checks if the space exists
    #
    # @param slug [String] slug of the space
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def space_exists?(slug, params={}, headers=default_headers)
      info("Checking if the \"#{slug}\" space exists")
      response = get("#{@api_url}/spaces/#{slug}", params, headers)
      response.status == 200
    end

  end
end
