module KineticSdk
  class Discussions

    # Add a Message without attachments
    #
    # @param discussion_id [String] id of the discussion
    # @param message [String] message
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_message(discussion_id, message, headers=header_bearer_auth)
      payload = { "message": message }
      info("Adding a message to the #{discussion_id} discussion")
      post("#{@api_url}/discussions/#{discussion_id}", payload, headers)
    end

    # Add a Message with attachments
    #
    # @param discussion_id [String] id of the discussion
    # @param properties [Hash] message properties
    #   - +message+ [String]
    #   - +attachments+ [File[]]
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_message_with_attachments(discussion_id, properties={}, headers=header_bearer_auth)
      info("Adding a message to the #{discussion_id} discussion")
      post_multipart("#{@api_url}/discussions/#{discussion_id}", properties, headers)
    end

    # Update a Message without attachments
    #
    # @param discussion_id [String] id of the discussion
    # @param message_id [String] id of the message
    # @param message [String] updated content of the message
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_message(discussion_id, message_id, message, headers=header_bearer_auth)
      payload = { "message": message }
      info("Updating the #{message_id} message in the #{discussion_id} discussion")
      put("#{@api_url}/discussions/#{discussion_id}/messages/#{message_id}", payload, headers)
    end

  end
end
