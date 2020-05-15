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
        @logger.info("Attribute: #{attribute.inspect}")
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
        @logger.info("Updating attribute \"#{attribute_name}\" = \"#{attribute_value}\" in the \"#{space_slug}\" space.")
      else
        @logger.info("Adding attribute \"#{attribute_name}\" = \"#{attribute_value}\" to the \"#{space_slug}\" space.")
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
      @logger.info("Updating Space \"#{@space_slug}\"")
      put("#{@api_url}/space", body, headers)
    end

    # Export a space to the export_directory
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return nil
    def export_space(headers=default_headers)
      raise StandardError.new "An export directory must be defined to export space." if @options[:export_directory].nil?
      @logger.info("Exporting space definition to #{@options[:export_directory]}.")
      # Build up the tree of how files should be written
      export_shape = prepare_shape(
        "space.bridges.{name}",
        "space.datastore.forms.{slug}",
        "space.kapps.{slug}.categories",
        "space.kapps.{slug}.categoryAttributeDefinitions",
        "space.kapps.{slug}.forms.{slug}",
        "space.kapps.{slug}.formAttributeDefinitions",
        "space.kapps.{slug}.formTypes",
        "space.kapps.{slug}.kappAttributeDefinitions",
        "space.kapps.{slug}.securityPolicyDefinitions",
        "space.kapps.{slug}.webhooks.{name}",
        "space.kapps.{slug}.webApis.{slug}",
        "space.models.{name}",
        "space.teams.{name}",
        "space.datastoreFormAttributeDefinitions",
        "space.securityPolicyDefinitions",
        "space.spaceAttributeDefinitions",
        "space.teamAttributeDefinitions",
        "space.userAttributeDefinitions",
        "space.userProfileAttributeDefinitions",
        "space.webApis.{slug}",
        "space.webhooks.{name}",
      )
      core_data = get("#{@api_url}/space", { 'export' => true}, headers).content
      process_export(@options[:export_directory], export_shape, core_data)
      @logger.info("Finished exporting space definition to #{@options[:export_directory]}.")
    end

    # Find the space
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_space(params={}, headers=default_headers)
      @logger.info("Finding Space \"#{@space_slug}\"")
      get("#{@api_url}/space", params, headers)
    end

    # Imports a full space definition from the export_directory
    #
    # @param slug [String] the slug of the space that is being imported
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return nil
    def import_space(slug, headers=default_headers)
      raise StandardError.new "An export directory must be defined to import space." if @options[:export_directory].nil?
      @logger.info("Importing space definition from #{@options[:export_directory]}.")

      # Loop over all provided files sorting files before folders
      Dir["#{@options[:export_directory]}/**/*.json"].map { |file| [file.count("/"), file] }.sort.map { |file| file[1] }.each do |file|
        rel_path = file.gsub("#{@options[:export_directory]}/", '')
        body = JSON.parse(File.read(file))
        if rel_path == "space.json"
          api_path = "/space"
          @logger.info("Importing #{rel_path} to #{api_path}.")
          body['slug'] = slug
          resp = put("#{@api_url}#{api_path}", body, headers)
        elsif body.is_a?(Array)
          api_path = "/#{rel_path.sub(/^space\//,'').sub(/\.json$/,'')}"
          body.each do |part|
            @logger.info("Importing #{rel_path} to #{api_path}.")
            resp = post("#{@api_url}#{api_path}", part, headers)
          end
        else
          api_path = "/#{rel_path.sub(/^space\//,'').sub(/\/[^\/]+$/,'')}"
          # TODO: Remove this block when core API is updated to not export Key
          if api_path == "/bridges" && body.has_key?("key")
            body.delete("key")
          end
          @logger.info("Importing #{rel_path} to #{api_path}.")
          resp = post("#{@api_url}#{api_path}", body, headers)
          # TODO: Remove this block when core API is updated to not pre-create SPDs
          if api_path == "/kapps"
            kapp_slug = resp.content["kapp"]["slug"]
            delete_security_policy_definitions(kapp_slug)
            delete_form_types_on_kapp(kapp_slug)
          end
        end
      end
      @logger.info("Finished importing space definition to #{@options[:export_directory]}.")
    end

    # Checks if the space exists
    #
    # @param slug [String] slug of the space
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def space_exists?(slug, params={}, headers=default_headers)
      @logger.info("Checking if the \"#{slug}\" space exists")
      response = get("#{@api_url}/spaces/#{slug}", params, headers)
      response.status == 200
    end

  end
end
