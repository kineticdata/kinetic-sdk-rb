require "spec_helper"

RSpec.describe KineticSdk::Core do
  # jwt.rb only reads status, content, headers and message off the response.
  FakeResponse = Struct.new(:status, :content, :headers, :message, keyword_init: true)

  def json_response(status, content, message = "OK")
    FakeResponse.new(status: status, content: content, headers: {}, message: message)
  end

  def html_response(status, message, correlation_id = nil)
    headers = correlation_id.nil? ? {} : { "x-kinetic-cid" => correlation_id }
    FakeResponse.new(status: status, content: {}, headers: headers, message: message)
  end

  # Captures the single token request the SDK makes.
  def stub_token_request(sdk, response)
    request = {}
    allow(sdk).to receive(:post) do |url, payload, headers, _http_options|
      request[:url] = url
      request[:payload] = payload
      request[:headers] = headers
      response
    end
    request
  end

  let(:token_response) do
    json_response(200, { "access_token" => "a-jwt", "token_type" => "Bearer", "expires_in" => 1800 })
  end

  describe "#oauth_url" do
    it "is space scoped when built from an app server url" do
      sdk = core_sdk(app_server_url: "http://localhost:8080/kinetic", space_slug: "acme")
      expect(sdk.oauth_url).to eq("http://localhost:8080/kinetic/acme/app/oauth2")
    end

    it "is space scoped when built from a space server url" do
      sdk = core_sdk(space_server_url: "https://acme.myapp.io", space_slug: "acme")
      expect(sdk.oauth_url).to eq("https://acme.myapp.io/app/oauth2")
    end
  end

  describe "#jwt_token" do
    let(:sdk) { core_sdk(app_server_url: "http://localhost:8080/kinetic", space_slug: "acme") }

    it "posts a client_credentials grant to the space scoped token endpoint" do
      request = stub_token_request(sdk, token_response)
      sdk.jwt_token("a-client", "a-secret")

      expect(request[:url]).to eq("http://localhost:8080/kinetic/acme/app/oauth2/token")
      expect(URI.decode_www_form(request[:payload]).to_h).to include(
        "grant_type" => "client_credentials",
        "scope" => "full",
      )
    end

    it "authenticates the client with client_secret_post and asks for json" do
      request = stub_token_request(sdk, token_response)
      sdk.jwt_token("a-client", "a-secret")

      expect(URI.decode_www_form(request[:payload]).to_h).to include(
        "client_id" => "a-client",
        "client_secret" => "a-secret",
      )
      expect(request[:headers]["Accept"]).to eq("application/json")
      expect(request[:headers]["Content-Type"]).to eq("application/x-www-form-urlencoded")
    end

    # client_secret_basic would require form-urlencoding the credentials before base64
    # encoding them (RFC 6749 2.3.1). Sending no Authorization header at all avoids the
    # question, and keeps the secret out of the debug log, which prints headers.
    it "sends no Authorization header" do
      request = stub_token_request(sdk, token_response)
      sdk.jwt_token("a-client", "a-secret")
      expect(request[:headers].keys.map(&:downcase)).not_to include("authorization")
    end

    it "strips an inherited Authorization header so it cannot compete with the form credentials" do
      request = stub_token_request(sdk, token_response)
      sdk.jwt_token("a-client", "a-secret", sdk.send(:header_basic_auth, "the-user", "the-password"))

      expect(request[:headers].keys.map(&:downcase)).not_to include("authorization")
      expect(URI.decode_www_form(request[:payload]).to_h["client_secret"]).to eq("a-secret")
    end

    # The bug: Kinetic Coordinator generates integration user passwords from a character
    # set that includes "+". Sent raw through client_secret_basic, Spring's
    # ClientSecretBasicAuthenticationConverter URLDecoder.decode'd that "+" into a space
    # and the bcrypt comparison failed with invalid_client.
    describe "secrets containing characters that form encoding is sensitive to" do
      tricky = {
        "plus" => "abc+def",
        "percent" => "abc%def",
        "colon" => "abc:def",
        "space" => "abc def",
        "ampersand" => "abc&def",
        "equals" => "abc=def",
        "coordinator style" => "aB3~`$^&*()-+[{]}|;:,<.>/",
      }

      tricky.each do |name, secret|
        it "round trips a secret containing a #{name}" do
          request = stub_token_request(sdk, token_response)
          sdk.jwt_token("a-client", secret)

          # Decoding the body the way the server does must yield the original secret.
          expect(URI.decode_www_form(request[:payload]).to_h["client_secret"]).to eq(secret)
        end
      end

      it "percent escapes a plus rather than sending it raw" do
        request = stub_token_request(sdk, token_response)
        sdk.jwt_token("a-client", "abc+def")
        expect(request[:payload]).to include("client_secret=abc%2Bdef")
      end

      it "round trips a client id containing a plus" do
        request = stub_token_request(sdk, token_response)
        sdk.jwt_token("a+client", "a-secret")
        expect(URI.decode_www_form(request[:payload]).to_h["client_id"]).to eq("a+client")
      end
    end

    it "returns the response so callers can read the access token" do
      stub_token_request(sdk, token_response)
      expect(sdk.jwt_token("a-client", "a-secret").content["access_token"]).to eq("a-jwt")
    end

    # The authorization code flow this replaced is a user facing endpoint in Core 7.
    it "never calls the authorize endpoint" do
      request = stub_token_request(sdk, token_response)
      sdk.jwt_token("a-client", "a-secret")
      expect(request[:url]).not_to include("authorize")
      expect(sdk).not_to respond_to(:jwt_code)
    end

    describe "scope" do
      it "defaults to full" do
        request = stub_token_request(sdk, token_response)
        sdk.jwt_token("a-client", "a-secret")
        expect(URI.decode_www_form(request[:payload]).to_h["scope"]).to eq("full")
      end

      it "is configurable through the oauth_scope option" do
        scoped = core_sdk(app_server_url: "http://localhost:8080/kinetic", space_slug: "acme",
                          extra_options: { oauth_scope: "submissions:read" })
        request = stub_token_request(scoped, token_response)
        scoped.jwt_token("a-client", "a-secret")
        expect(URI.decode_www_form(request[:payload]).to_h["scope"]).to eq("submissions:read")
      end

      it "falls back to the default when the option is set to nil" do
        scoped = core_sdk(app_server_url: "http://localhost:8080/kinetic", space_slug: "acme",
                          extra_options: { oauth_scope: nil })
        request = stub_token_request(scoped, token_response)
        scoped.jwt_token("a-client", "a-secret")
        expect(URI.decode_www_form(request[:payload]).to_h["scope"]).to eq("full")
      end

      it "is omitted entirely when set to an empty string" do
        scoped = core_sdk(app_server_url: "http://localhost:8080/kinetic", space_slug: "acme",
                          extra_options: { oauth_scope: "" })
        request = stub_token_request(scoped, token_response)
        scoped.jwt_token("a-client", "a-secret")
        payload = URI.decode_www_form(request[:payload]).to_h
        expect(payload).to include("grant_type" => "client_credentials")
        expect(payload).not_to have_key("scope")
      end
    end

    describe "error handling" do
      it "reports a 401 as invalid or unregistered client credentials" do
        stub_token_request(sdk, json_response(401, { "error" => "invalid_client" }, "Unauthorized"))
        expect { sdk.jwt_token("a-client", "bad-secret") }
          .to raise_error(StandardError, /401 invalid_client.*no such client is registered in this space/m)
      end

      # A client without the client_credentials grant (a public client, or the built in
      # system client) is rejected here rather than at the authorize endpoint.
      it "surfaces the OAuth error and description on a 400" do
        stub_token_request(sdk, json_response(400, {
          "error" => "unauthorized_client",
          "error_description" => "The client is not authorized to use this grant type",
        }, "Bad Request"))
        expect { sdk.jwt_token("a-client", "a-secret") }
          .to raise_error(StandardError, /400 unauthorized_client - The client is not authorized/)
      end

      # Regression: Core answers some failures with its generic HTML error page, which
      # carries no OAuth error code. Dumping the inspected response made the original
      # production failure very hard to diagnose.
      it "reports the correlation id when the body is html rather than a json error" do
        stub_token_request(sdk, html_response(400, "Bad Request", "abc-123"))
        expect { sdk.jwt_token("a-client", "a-secret") }
          .to raise_error(StandardError, /400 Bad Request \(correlation id abc-123\)/)
      end

      it "does not dump the whole response object into the message" do
        stub_token_request(sdk, html_response(400, "Bad Request", "abc-123"))
        expect { sdk.jwt_token("a-client", "a-secret") }
          .to raise_error(StandardError) { |e| expect(e.message).not_to include("#<") }
      end
    end
  end
end
