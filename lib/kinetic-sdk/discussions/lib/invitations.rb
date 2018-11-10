module KineticSdk
  class Discussions

    # Invite an email that doesn't have a user account
    #
    # @param discussion_id [String] id of the discussion
    # @param email [String] email to invite
    # @param message [String] message sent with the invitation
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_invitation_by_email(discussion_id, email, message=nil, headers=header_bearer_auth)
      payload = { "email" => email }
      payload["message"] = message unless message.nil?
      info("Inviting #{email} to the #{discussion_id} discussion")
      post("#{@api_url}/discussions/#{discussion_id}/invitations", payload, headers)
    end

    # Invite a user that already has an account
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username to invite
    # @param message [String] message sent with the invitation
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_invitation_by_username(discussion_id, username, message=nil, headers=header_bearer_auth)
      payload = { "username" => username }
      payload["message"] = message unless message.nil?
      info("Inviting #{username} to the #{discussion_id} discussion")
      post("#{@api_url}/discussions/#{discussion_id}/invitations", payload, headers)
    end

    # Delete an email invitation
    #
    # @param discussion_id [String] id of the discussion
    # @param email [String] email the invitation was sent to
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_invitation_by_email(discussion_id, email, headers=header_bearer_auth)
      info("Deleting the email invitation to the #{discussion_id} discussion for #{email}")
      delete("#{@api_url}/discussions/#{discussion_id}/invitations/#{encode(email)}?email=true", headers)
    end

    # Delete a user invitation
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username the invitation was sent to
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_invitation_by_username(discussion_id, username, headers=header_bearer_auth)
      info("Deleting the user invitation to the #{discussion_id} discussion for #{username}")
      delete("#{@api_url}/discussions/#{discussion_id}/invitations/#{encode(username)}", headers)
    end

    # Resend an email invitation
    #
    # @param discussion_id [String] id of the discussion
    # @param email [String] email the invitation was sent to
    # @param message [String] updated message to send with the invitation
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def resend_invitation_by_email(discussion_id, email, message, headers=header_bearer_auth)
      payload = {}
      payload["message"] = message unless message.nil?
      info("Reinviting #{email} to the #{discussion_id} discussion")
      put("#{@api_url}/discussions/#{discussion_id}/invitations/#{encode(email)}?email=true", payload, headers)
    end

    # Resend a user invitation
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username the invitation was sent to
    # @param message [String] updated message to send with the invitation
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def resend_invitation_by_username(discussion_id, username, message, headers=header_bearer_auth)
      payload = {}
      payload["message"] = message unless message.nil?
      info("Reinviting #{username} to the #{discussion_id} discussion")
      put("#{@api_url}/discussions/#{discussion_id}/invitations/#{encode(username)}", payload, headers)
    end

  end
end
