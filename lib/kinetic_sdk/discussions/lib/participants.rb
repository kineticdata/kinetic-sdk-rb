module KineticSdk
  class Discussions

    # Create a participant for an existing user
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username of the user
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_participant(discussion_id, username, headers=default_jwt_headers)
      payload = { "username" => username }
      info("Participant #{username} joining the #{discussion_id} Discussion")
      post("#{@api_url}/discussions/#{discussion_id}/participants", payload, headers)
    end

    # Delete a participant
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username of the participant
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_participant(discussion_id, username, headers=header_bearer_auth)
      info("Participant #{username} is leaving the #{discussion_id} Discussion")
      delete("#{@api_url}/discussions/#{discussion_id}/participants/#{encode(username)}", headers)
    end

    # Find participants in a discussion
    #
    # @param discussion_id [String] id of the discussion
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_participants(discussion_id, params={}, headers=default_jwt_headers)
      info("Finding Participants in the #{discussion_id} Discussion")
      get("#{@api_url}/discussions/#{discussion_id}/participants", params, headers)
    end

    # Find a participant in a discussion
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username of the participant
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_participant(discussion_id, username, params={}, headers=default_jwt_headers)
      info("Finding the #{username} Participant in the #{discussion_id} Discussion")
      get("#{@api_url}/discussions/#{discussion_id}/participants/#{encode(username)}", params, headers)
    end

    # Update a participant in a discussion
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username of the participant
    # @param properties [Hash] participant properties to update
    #   - +isMuted+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_participant(discussion_id, username, properties={}, headers=default_jwt_headers)
      info("Updating the #{username} Participant in the #{discussion_id} Discussion")
      put("#{@api_url}/discussions/#{discussion_id}/participants/#{encode(username)}", properties, headers)
    end

  end
end
