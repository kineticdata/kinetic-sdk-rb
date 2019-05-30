module KineticSdk
  class Discussions

    # Add a Related Item to a discussion
    #
    # @param discussion_id [String] id of the discussion
    # @param type [String] type of related item
    # @param key [String] key that identifies the related item
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_related_item(discussion_id, type, key, headers=default_jwt_headers)
      payload = {"type": type, "key": key}
      info("Adding a related item of type #{type} and key #{key} to the #{discussion_id} Discussion")
      post("#{@api_url}/discussions/#{discussion_id}/relatedItems", payload, headers)
    end

    # Delete a Related Item from a discussion
    #
    # @param discussion_id [String] id of the discussion
    # @param type [String] type of related item
    # @param key [String] key that identifies the related item
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_related_item(discussion_id, type, key, headers=header_bearer_auth)
      info("Deleting related item of type #{type} and key #{key} from the #{discussion_id} Discussion")
      delete("#{@api_url}/discussions/#{discussion_id}/relatedItems/#{encode(type)}/#{encode(key)}", payload, headers)
    end

    # Find Related Items in a Discussion
    #
    # @param discussion_id [String] id of the discussion
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_related_items(discussion_id, params={}, headers=default_jwt_headers)
      info("Finding related items in the #{discussion_id} Discussion")
      get("#{@api_url}/discussions/#{discussion_id}/relatedItems", params, headers)
    end

    # Find a Related Item in a Discussion
    #
    # @param discussion_id [String] id of the discussion
    # @param type [String] type of the related item
    # @param key [String] key that identifies the related item
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_related_item(discussion_id, type, key, params={}, headers=default_jwt_headers)
      info("Finding the related item of type #{type} and key #{key} in the #{discussion_id} Discussion")
      get("#{@api_url}/discussions/#{discussion_id}/relatedItems/#{encode(type)}/#{encode(key)}", params, headers)
    end

  end
end
