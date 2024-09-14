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
      core_data = find_space({ 'export' => true }, headers).content
      process_export(@options[:export_directory], export_shape, core_data)
      export_workflows(headers)
      @logger.info("Finished exporting space definition to #{@options[:export_directory]}.")
    end

    # Exports linked workflows for the space, kapps, and forms. This method is automatically called from `KineticSdk.Core.export_space()`.
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return nil
    def export_workflows(headers=default_headers)
      # Workflows were introduced in core v6
      version = app_version(headers).content["version"]
      if version && version["version"] < "6"
        @logger.info("Skip exporting workflows because the Core server version doesn't support workflows.")
        return
      end

      raise StandardError.new "An export directory must be defined to export workflows." if @options[:export_directory].nil?
      @logger.info("Exporting workflows to #{@options[:export_directory]}.")

      # space workflows
      space_workflows = find_space_workflows({ "include" => "details" }, headers).content["workflows"] || []
      space_workflows.select { |wf| !wf["event"].nil? }.each do |workflow|
        evt = workflow["event"].to_s.slugify
        name = workflow["name"].to_s.slugify
        if evt.empty? || name.empty?
          raise "Some workflows are currently in an orphaned or missing state. You can open the Workflows tab for the space in the space console, and run the repair to attempt to resolve this issue."
        end
        @logger.info(workflow)
        filename = "#{File.join(@options[:export_directory], "space", "workflows", evt, name)}.json"
        workflow_json = find_space_workflow(workflow["id"], {}, headers).content["treeJson"]
        write_object_to_file(filename, workflow_json)
      end

      space_content = find_space({ 'include' => "kapps.details,kapps.forms.details" }).content["space"]

      # kapp workflows
      space_content["kapps"].each do |kapp|
        kapp_workflows = find_kapp_workflows(kapp["slug"], {}, headers).content["workflows"] || []
        kapp_workflows.select { |wf| !wf["event"].nil? }.each do |workflow|
          evt = workflow["event"].to_s.slugify
          name = workflow["name"].to_s.slugify
          if evt.empty? || name.empty?
            raise "Some workflows are currently in an orphaned or missing state. You can open the Workflows tab for the #{kapp["name"]} kapp in the space console, and run the repair to attempt to resolve this issue."
          end
          filename = "#{File.join(@options[:export_directory], "space", "kapps", kapp["slug"], "workflows", evt, name)}.json"
          workflow_json = find_kapp_workflow(kapp["slug"], workflow["id"], {}, headers).content["treeJson"]
          write_object_to_file(filename, workflow_json)
        end

        # form workflows
        kapp["forms"].each do |form|
          form_workflows = find_form_workflows(kapp["slug"], form["slug"], {}, headers).content["workflows"] || []
          form_workflows.select { |wf| !wf["event"].nil? }.each do |workflow|
            evt = workflow["event"].to_s.slugify
            name = workflow["name"].to_s.slugify
            if evt.empty? || name.empty?
              raise "Some workflows are currently in an orphaned or missing state. You can open the Workflows tab for the #{kapp["name"]} > #{form["name"]} form in the space console, and run the repair to attempt to resolve this issue."
            end
            filename = "#{File.join(@options[:export_directory], "space", "kapps", kapp["slug"], "forms", form["slug"], "workflows", evt, name)}.json"
            workflow_json = find_form_workflow(kapp["slug"], form["slug"], workflow["id"], {}, headers).content["treeJson"]
            write_object_to_file(filename, workflow_json)
          end
        end
      end
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

    # Imports a full space definition from the export_directory, except for workflows. Those must be imported separately after
    # the Kinetic Platform source exists in task.
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
        elsif rel_path.match?(/.*\/workflows\/.*/)
          # skip workflows,they are inported independently
          next
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

    # Imports the workflows for the space. This method should be called after importing the Kinetic Platform source into task.
    #
    # @param slug [String] the slug of the space that is being imported
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return nil
    def import_workflows(slug, headers=default_headers)
      # Workflows were introduced in core v6
      version = app_version(headers).content["version"]
      if version && version["version"] < "6"
        @logger.info("Skip importing workflows because the Core server version doesn't support workflows.")
        return
      end

      raise StandardError.new "An export directory must be defined to import space." if @options[:export_directory].nil?
      @logger.info("Importing workflows from #{@options[:export_directory]}.")

      # Map of existing workflows by space, kapp, form
      existing_workflows_cache = {}
      # Regular expressions to match workflow paths by space, kapp, or form
      form_re = /^\/kapps\/(?<kapp_slug>[a-z0-9]+(?:-[a-z0-9]+)*)\/forms\/(?<form_slug>[a-z0-9]+(?:-[a-z0-9]+)*)\/workflows/
      kapp_re = /^\/kapps\/(?<kapp_slug>[a-z0-9]+(?:-[a-z0-9]+)*)\/workflows/
      space_re = /^\/workflows/

      # Loop over all provided files sorting files before folders
      Dir["#{@options[:export_directory]}/space/**/workflows/**/*.json"].map { |file| [file.count("/"), file] }.sort.map { |file| file[1] }.each do |file|
        rel_path = file.sub("#{@options[:export_directory]}/", '')
        path_parts = File.dirname(rel_path).split(File::SEPARATOR)
        api_parts_path = path_parts[0..-1]
        api_path = "/#{api_parts_path.join("/").sub(/^space\//,'').sub(/\/[^\/]+$/,'')}"

        # populate the existing workflows for the workflowable object
        matches = form_re.match(api_path)
        # form workflows
        if matches
          form_slug = matches["form_slug"]
          kapp_slug = matches["kapp_slug"]
          map_key = self.space_slug + "|" + kapp_slug + "|" + form_slug
          if !existing_workflows_cache.has_key?(map_key)
            response = find_form_workflows(kapp_slug, form_slug, { "includes" => "details" }, headers)
            existing_workflows_cache[map_key] = response.content["workflows"]
          end
        else
          matches = kapp_re.match(api_path)
          # kapp workflows
          if matches
            kapp_slug = matches["kapp_slug"]
            map_key = self.space_slug + "|" + kapp_slug
            if !existing_workflows_cache.has_key?(map_key)
              response = find_kapp_workflows(kapp_slug, { "includes" => "details" }, headers)
              existing_workflows_cache[map_key] = response.content["workflows"]
            end
          else
            # space workflows
            map_key = self.space_slug
            if !existing_workflows_cache.has_key?(map_key)
              response = find_space_workflows({ "includes" => "details" }, headers)
              existing_workflows_cache[map_key] = response.content["workflows"]
            end
          end
        end

        tree_json = JSON.parse(File.read(file))
        event = path_parts.last.split("-").map { |part| part.capitalize }.join(" ")
        name = tree_json["name"]

        body = {
          "event" => event,
          "name" => name,
          "treeJson" => tree_json
        }

        # check if the workflow already exists
        existing_workflow = (existing_workflows_cache[map_key] || []).select { |wf|
          wf["event"] == event && wf["name"] == name
        }.first

        if existing_workflow
          workflow_id = existing_workflow["id"]
          url = "#{@api_url}#{api_path}/#{workflow_id}"
          @logger.info("Updating #{event} workflow #{workflow_id} from #{rel_path} to #{url}")
          resp = put(url, body, headers)
          @logger.warn("Failed to update workflow (#{resp.code}): #{resp.content}") unless resp.code == "200"
        else
          url = "#{@api_url}#{api_path}"
          @logger.info("Importing #{event} workflow from #{rel_path} to #{url}")
          resp = post(url, body, headers)
          @logger.warn("Failed to import workflow (#{resp.code}): #{resp.content}") unless resp.code == "200"
        end
      end
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


    # Find Space workflows
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_space_workflows(params={}, headers=default_headers)
      @logger.info("Find space workflows")
      get("#{@api_url}/workflows", params, headers)
    end


    # Find a space workflow
    #
    # @param workflow_id [UUID] the workflow UUID
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_space_workflow(workflow_id, params={}, headers=default_headers)
      @logger.info("Find space workflow #{workflow_id}")
      get("#{@api_url}/workflows/#{workflow_id}", params, headers)
    end


    # Add Space workflow
    #
    # @param payload [Hash] hash of required workflow properties
    #   - +event+
    #   - +name+
    #   - +treeXml+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_space_workflow(payload, headers=default_headers)
      @logger.info("Add workflow to the space")
      post("#{@api_url}/workflows", payload, headers)
    end


    # Delete Space workflow
    #
    # @param workflow_id [UUID] the workflow UUID
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_space_workflow(workflow_id, headers=default_headers)
      @logger.info("Delete workflow from the space")
      post("#{@api_url}/workflows/#{workflow_id}", payload, headers)
    end

  end
end
