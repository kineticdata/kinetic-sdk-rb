module KineticSdk
  class Task

    # Delete a Handler
    #
    # @param definition_id [String] the handler definition id
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_handler(definition_id, headers=header_basic_auth)
      @logger.info("Deleting Handler \"#{definition_id}\"")
      delete("#{@api_url}/handlers/#{definition_id}", headers)
    end

    # Delete all Handlers
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_handlers(headers=header_basic_auth)
      @logger.info("Deleting all handlers")
      (find_handlers(headers).content['handlers'] || []).each do |handler|
        delete("#{@api_url}/handlers/#{handler['definitionId']}", headers)
      end
    end

    # Find all handlers
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_handlers(params={}, headers=header_basic_auth)
      @logger.info("Find all handlers")
      get("#{@api_url}/handlers", params, headers)
    end

    # Find a handler
    #
    # @param definition_id [String] the definition id of the handler
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_handler(definition_id, params={}, headers=header_basic_auth)
      @logger.info("Finding handler \"#{definition_id}\"")
      get("#{@api_url}/handlers/#{definition_id}", params, headers)
    end

    # Import a handler file
    #
    # If the handler already exists on the server, this will fail unless forced to overwrite.
    #
    # @param handler [File] handler zip package file
    # @param force_overwrite [Boolean] whether to overwrite a handler if it exists, default is false
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def import_handler(handler, force_overwrite=false, headers=header_basic_auth)
      body = { "package" => handler }
      @logger.info("Importing Handler #{File.basename(handler)}")
      post_multipart("#{@api_url}/handlers?force=#{force_overwrite}", body, headers)
    end

    # Import handlers from export directory
    #
    # If the handlers already exists on the server, this will fail unless forced to overwrite.
    #
    # @param force_overwrite [Boolean] whether to overwrite handlers if they exist, default is false
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def import_handlers(force_overwrite=false, headers=header_basic_auth)
      raise StandardError.new "An export directory must be defined to import handlers from." if @options[:export_directory].nil?
      @logger.info("Importing all Handlers from Export Directory")
      Dir["#{@options[:export_directory]}/handlers/*.zip"].sort.each do |file|
        handler_file = File.new(file, "rb")
        import_handler(handler_file, force_overwrite, headers)
      end
    end

    # Modifies the properties and info values for a handler
    #
    # @param definition_id [String] the definition id of the handler
    # @param body [Hash] the properties to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_handler(definition_id, body, headers=default_headers)
      @logger.info("Updating handler #{definition_id}")
      put("#{@api_url}/handlers/#{definition_id}", body, headers)
    end

    # Export a single handler
    #
    # @param definition_id [String] the definition id of the handler
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return nil
    def export_handler(definition_id, headers=header_basic_auth)
      raise StandardError.new "An export directory must be defined to export a handler." if @options[:export_directory].nil?
      @logger.info("Exporting handler \"#{definition_id}\" to #{@options[:export_directory]}.")
      # Create the handler directory if it doesn't yet exist
      handler_dir = FileUtils::mkdir_p(File.join(@options[:export_directory], "handlers"))
      handler_file = File.join(handler_dir, "#{definition_id}.zip")
      # write the file
      File.open(handler_file, "wb") do |file|
        file.write get("#{@api_url}/handlers/#{definition_id}/zip", {}, headers).content_string
      end
      @logger.info("Exported handler: #{definition_id} to #{handler_file}")
    end

    # Export all handlers
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return nil
    def export_handlers(headers=header_basic_auth)
      raise StandardError.new "An export directory must be defined to export handlers." if @options[:export_directory].nil?
      @logger.info("Exporting handlers to #{@options[:export_directory]}.")
      # Get the handler metadata to geta all handler_ids
      response = find_handlers(headers)
      # Parse the response and export each handler
      (response.content["handlers"] || []).each do |handler|
        export_handler(handler['definitionId'], headers)
      end
    end

  end
end
