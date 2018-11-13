module KineticSdk
  class Discussions

    # Add a Discussion
    #
    # @param properties [Hash] discussion properties
    #   - +title+
    #   - +description+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_discussion(properties={}, headers=default_jwt_headers)
      info("Adding the #{properties['title']} discussion")
      post("#{@api_url}/discussions", properties, headers)
    end

    # Delete a Discussion
    #
    # @param discussion_id [String] discussion_id of the discussion
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_discussion(discussion_id, headers=header_bearer_auth)
      info("Deleting Discussion \"#{discussion_id}\"")
      delete("#{@api_url}/discussions/#{discussion_id}", headers)
    end

    # Find Discussions
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_discussions(params={}, headers=default_jwt_headers)
      info("Finding Discussions.")
      get("#{@api_url}/discussions", params, headers)
    end

    # Find a Discussion
    #
    # @param discussion_id [String] id of the Discussion
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_discussion(discussion_id, params={}, headers=default_jwt_headers)
      info("Finding the \"#{discussion_id}\" Discussion.")
      get("#{@api_url}/discussions/#{discussion_id}", params, headers)
    end

    # Update a Discussion
    #
    # @param discussion_id [String] id of the Discussion
    # @param properties [Hash] form properties to update
    #   - +title+
    #   - +description+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_discussion(discussion_id, properties={}, headers=default_jwt_headers)
      info("Updating the \"#{discussion_id}\" Discussion.")
      put("#{@api_url}/discussions/#{discussion_id}", properties, headers)
    end

  end
end
