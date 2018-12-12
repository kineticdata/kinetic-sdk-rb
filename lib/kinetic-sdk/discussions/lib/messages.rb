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
      info("Adding a message to the #{discussion_id} Discussion")
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
      info("Adding a message to the #{discussion_id} Discussion")
      post_multipart("#{@api_url}/discussions/#{discussion_id}/messages", payload, headers)
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
      info("Updating the #{message_id} message in the #{discussion_id} Discussion")
      put("#{@api_url}/discussions/#{discussion_id}/messages/#{message_id}", payload, headers)
    end


    private

    def message_content(message)
      case message.class.name
      when 'Hash'
        content = message
      when 'Array'
        content = { "content" => message }
      else
        content = { "content" => [{ "type": "text", "value": message }] }
      end
    end

  end
end
