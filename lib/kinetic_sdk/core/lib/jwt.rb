module KineticSdk
  class Core

    # Gets an authentication token
    #
    # @param client_id [String] the oauth client id
    # @param client_secret [String] the oauth client secret
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def jwt_token(client_id, client_secret, headers = default_headers)
      # retrieve the jwt code
      jwt_code = jwt_code(client_id, headers)
      # retrieve the jwt token
      @logger.info("Retrieving JWT authorization token")
      url = "#{@server}/app/oauth/token?grant_type=authorization_code&response_type=token&client_id=#{client_id}&code=#{jwt_code}"
      token_headers = header_accept_json.merge(header_basic_auth(client_id, client_secret))
      response = post(url, {}, token_headers, { :max_redirects => 0 })

      if response.status == 401
        raise StandardError.new "#{response.message}, the oauth client id and secret are invalid."
      elsif response.status == 200
        response
      else
        raise StandardError.new "Unable to retrieve token: #{response}"
      end
    end

    # Gets an authentication code.
    #
    # This method should really never need to be called externally.
    #
    # @param client_id [String]
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def jwt_code(client_id, headers = default_headers)
      @logger.info("Retrieving JWT authorization code")
      url = "#{@server}/app/oauth/authorize?grant_type=authorization_code&response_type=code&client_id=#{client_id}"
      response = post(url, {}, headers, { :max_redirects => -1 })

      if response.status == 401
        raise StandardError.new "#{response.message}: #{response.content["error"]}"
      elsif response.status == 302 || response.status == 303
        location = response.headers["location"]
        if location.nil?
          raise StandardError.new "Unable to retrieve code: #{response.inspect}"
        else
          location.split("?code=").last.split("#/").first
        end
      else
        raise StandardError.new "Unable to retrieve code #{response.inspect}"
      end
    end
  end
end
