module KineticSdk
  class Task

    # Delete a tree.
    #
    # @param tree [String|Hash] either the tree title, or a hash consisting of component names
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     delete_tree("Kinetic Request CE :: Win a Car :: Complete")
    #
    # Example
    #
    #     delete_tree({
    #       "source_name" => "Kinetic Request CE",
    #       "group_name" => "Win a Car",
    #       "tree_name" => "Complete"
    #     })
    #
    def delete_tree(tree, headers=header_basic_auth)
      if tree.is_a? Hash
        title = "#{tree['source_name']} :: #{tree['group_name']} :: #{tree['tree_name']}"
      else
        title = "#{tree.to_s}"
      end
      @logger.info("Deleting Tree \"#{title}\"")
      delete("#{@api_url}/trees/#{encode(title)}", headers)
    end

    # Delete trees.
    #
    # If the source_name is provided, only trees that belong to the source
    # will be deleted, otherwise all trees will be deleted.
    #
    # @param source_name [String] the name of the source, or nil to delete all trees
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     delete_trees("Kinetic Request CE")
    #
    def delete_trees(source_name=nil, headers=header_basic_auth)
      if source_name.nil?
        @logger.info("Deleting all trees")
        params = {}
      else
        @logger.info("Deleting trees for Source \"#{source_name}\"")
        params = { "source" => source_name }
      end

      (find_trees(params, headers).content['trees'] || []).each do |tree|
        @logger.info("Deleting tree \"#{tree['title']}\"")
        delete("#{@api_url}/trees/#{encode(tree['title'])}", headers)
      end
    end


    # Find trees.
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     find_trees({ "source" => "Kinetic Request CE" })
    #
    # Example
    #
    #     find_trees({ "include" => "details" })
    #
    # Example
    #
    #     find_trees({ "source" => "Kinetic Request CE", "include" => "details" })
    #
    def find_trees(params={}, headers=header_basic_auth)
      @logger.info("Finding Trees")
      get("#{@api_url}/trees", params, headers)
    end

    # Find routines.
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     find_routines({ "source" => "Kinetic Request CE" })
    #
    # Example
    #
    #     find_routines({ "include" => "details" })
    #
    # Example
    #
    #     find_routines({ "source" => "Kinetic Request CE", "include" => "details" })
    #
    def find_routines(params={}, headers=header_basic_auth)
      @logger.info("Finding Routines")
      response = get("#{@api_url}/trees", params, headers)

      routines = []
      (response.content["trees"] || []).each do |tree|
        routines.push(tree) unless tree['definitionId'].nil?
      end
      final_content = { "trees" => routines }
      response.content= final_content
      response.content_string= final_content.to_json
      response
    end

    # Import a tree
    #
    # If the tree already exists on the server, this will fail unless forced
    # to overwrite.
    #
    # The source named in the tree content must also exist on the server, or
    # the import will fail.
    #
    # @param tree [String] content from tree file
    # @param force_overwrite [Boolean] whether to overwrite a tree if it exists, default is false
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def import_tree(tree, force_overwrite=false, headers=header_basic_auth)
      body = { "content" => tree }
      @logger.info("Importing Tree #{File.basename(tree)}")
      post_multipart("#{@api_url}/trees?force=#{force_overwrite}", body, headers)
    end

    # Import trees
    #
    # If the trees already exists on the server, this will fail unless forced
    # to overwrite.
    #
    # The source named in the trees content must also exist on the server, or
    # the import will fail.
    #
    # @param force_overwrite [Boolean] whether to overwrite a tree if it exists, default is false
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return nil
    def import_trees(force_overwrite=false, headers=header_basic_auth)
      raise StandardError.new "An export directory must be defined to import trees from." if @options[:export_directory].nil?
      @logger.info("Importing all Trees from Export Directory")
      Dir["#{@options[:export_directory]}/sources/**/*.xml"].sort.each do |file|
        tree_file = File.new(file, "rb")
        import_tree(tree_file, force_overwrite, headers)
      end
    end

    # Import a routine
    #
    # If the routine already exists on the server, this will fail unless
    # forced to overwrite.
    #
    # @param routine [String] content from routine file
    # @param force_overwrite [Boolean] whether to overwrite a routine if it exists, default is false
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def import_routine(routine, force_overwrite=false, headers=header_basic_auth)
      body = { "content" => routine }
      @logger.info("Importing Routine #{File.basename(routine)}")
      post_multipart("#{@api_url}/trees?force=#{force_overwrite}", body, headers)
    end

    # Import routines
    #
    # If the routines already exists on the server, this will fail unless forced
    # to overwrite.
    #
    # @param force_overwrite [Boolean] whether to overwrite routines if they exist, default is false
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return nil
    def import_routines(force_overwrite=false, headers=header_basic_auth)
      raise StandardError.new "An export directory must be defined to import trees from." if @options[:export_directory].nil?
      @logger.info("Importing all Routines from Export Directory")
      Dir["#{@options[:export_directory]}/routines/*.xml"].sort.each do |file|
        routine_file = File.new(file, "rb")
        import_routine(routine_file, force_overwrite, headers)
      end
    end

    # Find a single tree by title (Source Name :: Group Name :: Tree Name)
    #
    # @param title [String] The tree title
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     find_tree(
    #       "Kinetic Request CE :: Win a Car :: Complete",
    #       { "include" => "details" }
    #     )
    #
    def find_tree(title, params={}, headers=header_basic_auth)
      @logger.info("Finding the \"#{title}\" Tree")
      get("#{@api_url}/trees/#{encode(title)}", params, headers)
    end

    # Find a tree by Id
    #
    # @param tree_id [UUID] the tree UUID
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_tree_by_id(tree_id, params={}, headers=default_headers)
      @logger.info("Find tree by id")
      get("#{@api_url}/trees/guid/#{tree_id}", params, headers)
    end

    # Export a single tree or routine. This method will not export Kinetic Core 
    # workflows unless `export_opts[:include_workflows] => true` export option
    # is provided.
    #
    # @param title [String] the title of the tree or routine
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @param export_opts [Hash] hash of export options
    #   - :include_workflows => true|false (default: false)
    # @return nil
    #
    def export_tree(title, headers=header_basic_auth, export_opts={})
      raise StandardError.new "An export directory must be defined to export a tree." if @options[:export_directory].nil?
      @logger.info("Exporting tree \"#{title}\" to #{@options[:export_directory]}.")
      # Get the tree
      response = find_tree(title, { "include" => "details,export" })
      # Parse the response and export the tree
      tree = response.content
      if export_opts[:include_workflows] || (!tree.has_key?("event") || tree["event"].nil?)
          # determine which directory to write the file to
        if tree['sourceGroup'] == "-"
          # Create the directory if it doesn't yet exist
          routine_dir = FileUtils::mkdir_p(File.join(@options[:export_directory], "routines"))
          tree_file = File.join(routine_dir, "#{tree['name'].slugify}.xml")
        else
          # Create the directory if it doesn't yet exist
          tree_dir = FileUtils::mkdir_p(File.join(@options[:export_directory],"sources", tree['sourceName'].slugify , "trees"))
          tree_file = File.join(tree_dir, "#{tree['sourceGroup'].slugify}.#{tree['name'].slugify}.xml")
        end

        # write the file
        server_version = server_info(headers).content["version"]
        if server_version > "04.03.0z"
          File.write(tree_file, tree['export'])
        else
          xml_doc = REXML::Document.new(tree["export"])
          xml_doc.context[:attribute_quote] = :quote
          xml_formatter = Prettier.new
          xml_formatter.write(xml_doc, File.open(tree_file, "w"))
        end
        @logger.info("Exported #{tree['type']}: #{tree['title']} to #{tree_file}")
      else
        @logger.info("Did not export #{tree['type']}: #{tree['title']} because it is a Core linked workflow")
      end
    end

    # Export trees and local routines for a source, and global routines. This method will
    # not export Kinetic Core workflows unless `export_opts[:include_workflows] => true`
    # export option is provided.
    #
    # @param source_name [String] Name of the source to export trees and local routines
    #   - Leave blank or pass nil to export all trees and global routines
    #   - Pass "-" to export only global routines
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @param export_opts [Hash] hash of export options
    #   - :include_workflows => true|false (default: false)
    # @return nil
    def export_trees(source_name=nil, headers=header_basic_auth, export_opts={})
      raise StandardError.new "An export directory must be defined to export trees." if @options[:export_directory].nil?
      if source_name.nil?
        if export_opts[:include_workflows]
          @logger.info("Exporting all trees, routines, and workflows to #{@options[:export_directory]}.")
        else
          @logger.info("Exporting all trees and routines to #{@options[:export_directory]}.")
        end
        export_routines(headers)
        (find_sources({}, headers).content["sourceRoots"] || []).each do |sourceRoot|
          export_trees(sourceRoot['name'], headers, export_opts)
        end
        return
      elsif source_name == "-"
        @logger.info("Exporting global routines to #{@options[:export_directory]}.")
      else
        @logger.info("Exporting trees and local routines for source \"#{source_name}\" to #{@options[:export_directory]}.")
      end

      # Setup the parameters sent to the find_trees method.
      # limit and offset are used for pagination.
      limit, offset, count = 10, 0, nil
      params = {
        "source" => source_name,
        "include" => "details",
        "limit" => limit
      }

      # Paginate through all the trees and routines for the source
      while (count.nil? || offset < count)
        response = find_trees(params, headers)
        count = response.content["count"].to_i
        # Export each tree
        (response.content["trees"] || []).each do |tree|
          if export_opts[:include_workflows] || (!tree.has_key?("event") || tree["event"].nil?)
            export_tree(tree['title'], headers, export_opts)
          end
        end
        # Increment the offset to the next page
        offset += limit
        params["offset"] = offset
      end
    end


    # Export all global routines
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return nil
    def export_routines(headers=header_basic_auth)
      export_trees("-", headers)
    end

    # Create a new run of a tree
    #
    # @param title [String] title of the tree: Source Name, Group Name, Tree Name
    # @param body [Hash] properties to pass to the tree, what can be used/accepted
    #   depends on the source.
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def run_tree(title, body={}, headers=default_headers)
      @logger.info("Running tree #{title}")
      parts = title.split(" :: ")
      raise StandardError.new "Title is invalid: #{title}" if parts.size != 3
      url = "#{@api_v1_url}/run-tree/#{encode(parts[0])}/#{encode(parts[1])}/#{encode(parts[2])}"
      post(url, body, headers)
    end

    # Update a tree
    #
    # @param title [String] title of the tree: Source Name, Group Name, Tree Name
    # @param body [Hash] properties to pass to the tree
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_tree(title, body={}, headers=default_headers)
      @logger.info("Updating the \"#{title}\" Tree")
      put("#{@api_url}/trees/#{encode(title)}", body, headers)
    end

  end
end
