module KineticSdk
  class Task

    # Add an access key
    #
    # @param access_key [Hash] properties for the access key
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     add_access_key({
    #       "description" => "Description",
    #       "identifier" => "X54DLNU",
    #       "secret" => "xyz"
    #     })
    #
    # Example
    #
    #     add_access_key({
    #       "description" => "Description"
    #     })
    #
    # Example
    #
    #     add_access_key()
    #
    def add_access_key(access_key={}, headers=default_headers)
      info("Adding access key " + (access_key.has_key?('identifier') ? access_key['identifier'] : ""))
      response = post("#{@api_url}/access-keys", access_key, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Delete an access key
    #
    # @param identifier [String] access key identifier
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_access_key(identifier, headers=header_basic_auth)
      info("Deleting access key \"#{identifier}\"")
      response = delete("#{@api_url}/access-keys/#{encode(identifier)}", headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Delete all access keys
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_access_keys(headers=header_basic_auth)
      info("Deleting all access keys")
      find_response = find_access_keys(headers)
      if @options[:raise_exceptions] && [200].include?(find_response.status) == false
        raise "#{find_response.status} #{find_response.message}"
      end
      (find_response.content["accessKeys"] || []).each do |access_key|
        response = delete("#{@api_url}/access_keys/#{encode(access_key['identifier'])}", headers)
        if @options[:raise_exceptions] && [200].include?(response.status) == false
          raise "#{response.status} #{response.message}"
        end
      end
    end

    # Find all access keys
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_access_keys(params={}, headers=header_basic_auth)
      info("Finding all access keys")
      response = get("#{@api_url}/access-keys", params, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Find an access key
    #
    # @param identifier [String] access key identifier
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_access_key(identifier, params={}, headers=default_headers)
      info("Finding access key \"#{identifier}\"")
      response = get("#{@api_url}/access-keys/#{encode(identifier)}", params, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Update an access key
    #
    # @param identifier [String] access key identifier
    # @param body [Hash] properties to update, all optional
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Exammple
    #
    #     update_identifier("X54DLNU", {
    #       "description": "Updated access key"
    #     })
    #
    def update_access_key(identifier, body={}, headers=default_headers)
      info("Updating the \"#{identifier}\" access key")
      response = put("#{@api_url}/access-keys/#{encode(identifier)}", body, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

  end
end
