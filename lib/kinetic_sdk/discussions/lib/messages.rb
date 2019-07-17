module KineticSdk
  class Discussions

    # Add a Message without attachments
    #
    # If message parameter is a Hash, it assumes the message contains the
    # `content` property set to an array of the expected tokens (`type` 
    # and `value` properties).
    #
    # If message parameter is an Array, it assumes the message contains
    # the array of expected tokens (`type` and `value` properties).
    #
    # If message parameter is a string, it builds up the message `content`
    # property as a single `text` token with the value of the message
    # parameter.
    #
    # @param discussion_id [String] id of the discussion
    # @param message [String | Hash | Array] message
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_message(discussion_id, message, headers=default_jwt_headers)
      payload = message_content(message)
      @logger.info("Adding a message to the #{discussion_id} Discussion")
      post("#{@api_url}/discussions/#{discussion_id}/messages", payload, headers)
    end

    # Add a Message with attachments
    #
    # If properties['message'] parameter is a Hash, it assumes the message
    # contains the `content` property set to an array of the expected tokens
    # (`type` and `value` properties).
    #
    # If properties['message'] parameter is an Array, it assumes the message
    # contains the array of expected tokens (`type` and `value` properties).
    #
    # If properties['message'] parameter is a string, it builds up the message
    # `content` property as a single `text` token with the value of the
    # properties['message'] parameter.
    #
    # @param discussion_id [String] id of the discussion
    # @param properties [Hash] message properties
    #   - +message+ [String | Hash | Array] message
    #   - +attachments+ [File[]]
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_message_with_attachments(discussion_id, properties={}, headers=default_jwt_headers)
      payload = message_content(properties['message'])
      payload["attachments"] = properties['attachments']
      @logger.info("Adding a message to the #{discussion_id} Discussion")
      post_multipart("#{@api_url}/discussions/#{discussion_id}/messages", payload, headers)
    end

    # Find Messages in a Discussion
    #
    # @param discussion_id [String] id of the discussion
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_messages(discussion_id, params={}, headers=default_jwt_headers)
      @logger.info("Finding messages in the #{discussion_id} Discussion")
      get("#{@api_url}/discussions/#{discussion_id}/messages", params, headers)
    end

    # Find a Message in a Discussion
    #
    # @param discussion_id [String] id of the discussion
    # @param message_id [String] id of the message
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_message(discussion_id, message_id, params={}, headers=default_jwt_headers)
      @logger.info("Finding the #{message_id} message in the #{discussion_id} Discussion")
      get("#{@api_url}/discussions/#{discussion_id}/messages/#{message_id}", params, headers)
    end

    # Update a Message without new attachments
    #
    # If message parameter is a Hash, it assumes the message contains the
    # `content` property set to an array of the expected tokens (`type` 
    # and `value` properties).
    #
    # If message parameter is an Array, it assumes the message contains
    # the array of expected tokens (`type` and `value` properties).
    #
    # If message parameter is a string, it builds up the message `content`
    # property as a single `text` token with the value of the message
    # parameter.
    #
    # @param discussion_id [String] id of the discussion
    # @param message_id [String] id of the message
    # @param message [String | Hash | Array] updated content of the message
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_message(discussion_id, message_id, message, headers=default_jwt_headers)
      payload = message_content(message)
      @logger.info("Updating the #{message_id} message in the #{discussion_id} Discussion")
      put("#{@api_url}/discussions/#{discussion_id}/messages/#{message_id}", payload, headers)
    end

    # Update a Message with new attachments
    #
    # If message parameter is a Hash, it assumes the message contains the
    # `content` property set to an array of the expected tokens (`type` 
    # and `value` properties).
    #
    # If message parameter is an Array, it assumes the message contains
    # the array of expected tokens (`type` and `value` properties).
    #
    # If message parameter is a string, it builds up the message `content`
    # property as a single `text` token with the value of the message
    # parameter.
    #
    # @param discussion_id [String] id of the discussion
    # @param message_id [String] id of the message
    # @param message [String | Hash | Array] updated content of the message
    # @param attachments [File[]] new attachments to add to the message
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_message_with_attachments(discussion_id, message_id, message, attachments=[], headers=header_bearer_auth)
      payload = { "message" => message_content(message).to_json, "attachments" => attachments }
      @logger.info("Updating the #{message_id} message in the #{discussion_id} Discussion")
      post_multipart("#{@api_url}/discussions/#{discussion_id}/messages/#{message_id}", payload, headers)
    end

    # Download a message attachment
    #
    # **WARNING** This method downloads the entire attachment into memory. This
    # may cause problems with large files. To stream the attachment in chunks to
    # avoid consuming large amounts of memory, see the 
    # {export_message_attachment} method.
    #
    # @param discussion_id [String] id of the discussion
    # @param message_id [String] id of the message
    # @param document_id [String] id of the document in the filestore
    # @param filename [String] default name to use for the downloaded file
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def download_message_attachment(discussion_id, message_id, document_id, filename, params={}, headers=header_bearer_auth)
      @logger.info("Downloading the #{filename} file attachment in the #{discussion_id} Discussion")
      get("#{@api_url}/discussions/#{discussion_id}/messages/#{message_id}/files/#{document_id}/#{filename}", params, headers)
    end

    # Export a message attachment
    #
    # This method streams the attachment in chunks to avoid consuming large
    # amounts of memory.
    #
    # The message attachment will be saved to the 
    # `{export_directory}/{discussion_id}/files/{message_id}` directory, where:
    #
    #   * +export_directory+: the directory specified in the SDK configuration
    #   * +discussion_id+: the id of the discussion
    #   * +message_id+: the id of the message that contains the attachment
    #
    # If you want to work with the attachment in code rather than automatically
    # save it to a file, see the {download_message_attachment} method.
    #
    # @param discussion_id [String] id of the discussion
    # @param message_id [String] id of the message
    # @param document_id [String] id of the document in the filestore
    # @param filename [String] default name to use for the downloaded file
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    def export_message_attachment(discussion_id, message_id, document_id, filename, params={}, headers=header_bearer_auth)
      raise StandardError.new "An export directory must be defined to export a file attachment." if @options[:export_directory].nil?
      @logger.info("Exporting the #{filename} file attachment in the #{discussion_id} Discussion")
      # Create the export directory if it doesn't yet exist
      export_dir = FileUtils::mkdir_p(File.join(@options[:export_directory], discussion_id, "files", message_id))
      export_file = File.join(export_dir, filename)
      url = "#{@api_url}/discussions/#{discussion_id}/messages/#{message_id}/files/#{document_id}/#{filename}"
      stream_download_to_file(export_file, url, params, headers)
    end


    private

    def message_content(message)
      case message.class.name
      when 'Hash'
        message
      when 'Array'
        { "content" => message }
      else
        { "content" => [{ "type": "text", "value": message }] }
      end
    end

  end
end
