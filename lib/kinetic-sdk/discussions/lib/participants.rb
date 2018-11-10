module KineticSdk
  class Discussions

    # Create a participant for an existing user
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username of the user
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_participant(discussion_id, username, headers=header_bearer_auth)
      payload = { "username" => username }
      info("Participant #{username} joining the #{discussion_id} discussion")
      post("#{@api_url}/discussions/#{discussion_id}/participants", payload, headers)
    end

     # Delete a participant
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username of the participant
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_participant(discussion_id, username, headers=header_bearer_auth)
      info("Participant #{username} is leaving the #{discussion_id} discussion")
      delete("#{@api_url}/discussions/#{discussion_id}/participants/#{encode(username)}", headers)
    end

  end
end
