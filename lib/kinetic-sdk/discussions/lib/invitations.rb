module KineticSdk
  class Discussions

    # Invite an email that doesn't have a user account
    #
    # @param discussion_id [String] id of the discussion
    # @param email [String] email to invite
    # @param message [String] message sent with the invitation
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_invitation_by_email(discussion_id, email, message=nil, headers=default_jwt_headers)
      payload = { "email" => email }
      payload["message"] = message unless message.nil?
      info("Inviting #{email} to the #{discussion_id} Discussion")
      post("#{@api_url}/discussions/#{discussion_id}/invitations", payload, headers)
    end

    # Invite a user that already has an account
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username to invite
    # @param message [String] message sent with the invitation
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_invitation_by_username(discussion_id, username, message=nil, headers=default_jwt_headers)
      payload = { "username" => username }
      payload["message"] = message unless message.nil?
      info("Inviting #{username} to the #{discussion_id} Discussion")
      post("#{@api_url}/discussions/#{discussion_id}/invitations", payload, headers)
    end

    # Delete an email invitation
    #
    # @param discussion_id [String] id of the discussion
    # @param email [String] email the invitation was sent to
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_invitation_by_email(discussion_id, email, headers=header_bearer_auth)
      info("Deleting the email invitation to the #{discussion_id} Discussion for #{email}")
      delete("#{@api_url}/discussions/#{discussion_id}/invitations/#{encode(email)}?email=true", headers)
    end

    # Delete a user invitation
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username the invitation was sent to
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_invitation_by_username(discussion_id, username, headers=header_bearer_auth)
      info("Deleting the user invitation to the #{discussion_id} Discussion for #{username}")
      delete("#{@api_url}/discussions/#{discussion_id}/invitations/#{encode(username)}", headers)
    end

    # Find invitations in a discussion
    #
    # @param discussion_id [String] id of the discussion
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_invitations(discussion_id, params={}, headers=default_jwt_headers)
      info("Finding Invitations in the #{discussion_id} Discussion")
      get("#{@api_url}/discussions/#{discussion_id}/invitations", params, headers)
    end

    # Find an invitation in a discussion by email
    #
    # @param discussion_id [String] id of the discussion
    # @param email [String] email the invitation was sent to
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_invitation_by_email(discussion_id, email, params={}, headers=default_jwt_headers)
      params['email'] = 'true' if params['email'].nil?
      info("Finding the Invitation for email #{email} in the #{discussion_id} Discussion")
      get("#{@api_url}/discussions/#{discussion_id}/invitations/#{encode(email)}", params, headers)
    end

    # Find an invitation in a discussion by username
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username of the invitation
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_invitation_by_username(discussion_id, username, params={}, headers=default_jwt_headers)
      params.delete('email')
      info("Finding the Invitation for user #{username} in the #{discussion_id} Discussion")
      get("#{@api_url}/discussions/#{discussion_id}/invitations/#{encode(username)}", params, headers)
    end

    # Resend an email invitation
    #
    # @param discussion_id [String] id of the discussion
    # @param email [String] email the invitation was sent to
    # @param message [String] updated message to send with the invitation
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def resend_invitation_by_email(discussion_id, email, message, headers=default_jwt_headers)
      payload = {}
      payload["message"] = message unless message.nil?
      info("Reinviting #{email} to the #{discussion_id} Discussion")
      put("#{@api_url}/discussions/#{discussion_id}/invitations/#{encode(email)}?email=true", payload, headers)
    end

    # Resend a user invitation
    #
    # @param discussion_id [String] id of the discussion
    # @param username [String] username the invitation was sent to
    # @param message [String] updated message to send with the invitation
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def resend_invitation_by_username(discussion_id, username, message, headers=default_jwt_headers)
      payload = {}
      payload["message"] = message unless message.nil?
      info("Reinviting #{username} to the #{discussion_id} Discussion")
      put("#{@api_url}/discussions/#{discussion_id}/invitations/#{encode(username)}", payload, headers)
    end

  end
end
