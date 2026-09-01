module KineticSdk
  class Core

    # Gets an authentication token using the OAuth 2.0 client credentials grant.
    #
    # Kinetic Platform 7 runs a standards compliant authorization server, in which
    # `/app/oauth2/authorize` is an interactive endpoint: it expects an authenticated
    # browser session, a consent round trip, a registered redirect_uri, and PKCE. A
    # machine to machine client cannot drive it, and should not try - it exchanges its
    # own credentials for a token directly at the token endpoint instead.
    #
    # The OAuth client must be registered in the space as a confidential client (or with
    # no clientType, which defaults to confidential) so that it carries the
    # `client_credentials` grant. Public clients and the built in system client support
    # only `authorization_code`, and will be rejected here.
    #
    # @param client_id [String] the oauth client id
    # @param client_secret [String] the oauth client secret
    # @param headers [Hash] additional headers to send. The Accept, Authorization and
    #   Content-Type headers required by the token endpoint always take precedence.
    # @param scope [String] scope to request, defaults to the +:oauth_scope+ option (+full+)
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def jwt_token(client_id, client_secret, headers = {}, scope = oauth_scope)
      @logger.info("Retrieving JWT authorization token")
      url = "#{@oauth_url}/token"

      # The required headers are merged last so that a caller passing the SDK default
      # headers cannot replace the client's basic authentication with the user's.
      token_headers = headers
        .merge(header_accept_json)
        .merge(header_basic_auth(client_id, client_secret))
        .merge({ "Content-Type" => "application/x-www-form-urlencoded" })

      payload = { "grant_type" => "client_credentials" }
      payload["scope"] = scope unless scope.nil? || scope.to_s.empty?

      # Redirects are not followed: the token endpoint has no reason to redirect, and
      # following one would forward the client credentials to another host.
      response = post(url, URI.encode_www_form(payload), token_headers, { :max_redirects => 0 })

      case response.status
      when 200
        response
      when 401
        raise StandardError.new(
          "Unable to retrieve token: #{oauth_error_message(response)}. The oauth client id " \
          "and secret are invalid, or no such client is registered in this space."
        )
      else
        raise StandardError.new("Unable to retrieve token: #{oauth_error_message(response)}")
      end
    end

    private

    # Builds an actionable message from an OAuth error response.
    #
    # The authorization server answers most failures with a JSON OAuth error, but falls
    # back to Core's generic HTML error page for others. That page carries no error code,
    # only a correlation id in the X-Kinetic-CID response header, which is what is needed
    # to find the matching entry in the server log.
    #
    # @param response [KineticSdk::Utils::KineticHttpResponse] the failed response
    # @return [String] a single line description of the failure
    def oauth_error_message(response)
      content = response.content.is_a?(Hash) ? response.content : {}
      if content["error"]
        message = "#{response.status} #{content["error"]}"
        message += " - #{content["error_description"]}" if content["error_description"]
        message
      else
        message = "#{response.status} #{response.message}"
        headers = response.headers
        correlation_id = headers.is_a?(Hash) ? headers["x-kinetic-cid"] : nil
        message += " (correlation id #{correlation_id})" if correlation_id
        message
      end
    end
  end
end
