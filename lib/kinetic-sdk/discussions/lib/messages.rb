module KineticSdk
  class Discussions

    # Add a Message without attachments
    #
    # @param discussion_id [String] id of the discussion
    # @param message [String] message
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_message(discussion_id, message, headers=default_jwt_headers)
      payload = {
        "content": [{ "type": "text", "value": message }]
      }
      info("Adding a message to the #{discussion_id} Discussion")
      post("#{@api_url}/discussions/#{discussion_id}/messages", payload, headers)
    end

    # Add a Message with attachments
    #
    # @param discussion_id [String] id of the discussion
    # @param properties [Hash] message properties
    #   - +message+ [String]
    #   - +attachments+ [File[]]
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_message_with_attachments(discussion_id, properties={}, headers=default_jwt_headers)
      payload = {
        "content": [{ "type": "text", "value": properties['message'] }],
        "attachments": properties['attachments']
      }
      info("Adding a message to the #{discussion_id} Discussion")
      post_multipart("#{@api_url}/discussions/#{discussion_id}/messages", properties, headers)
    end

    # Find Messages in a Discussion
    #
    # @param discussion_id [String] id of the discussion
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_messages(discussion_id, params={}, headers=default_jwt_headers)
      info("Finding messages in the #{discussion_id} Discussion")
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
      info("Finding the #{message_id} message in the #{discussion_id} Discussion")
      get("#{@api_url}/discussions/#{discussion_id}/messages/#{message_id}", params, headers)
    end

    # Update a Message without attachments
    #
    # @param discussion_id [String] id of the discussion
    # @param message_id [String] id of the message
    # @param message [String] updated content of the message
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_message(discussion_id, message_id, message, headers=default_jwt_headers)
      payload = {
        "content": [{ "type": "text", "value": message }]
      }
      info("Updating the #{message_id} message in the #{discussion_id} Discussion")
      put("#{@api_url}/discussions/#{discussion_id}/messages/#{message_id}", payload, headers)
    end

  end
end