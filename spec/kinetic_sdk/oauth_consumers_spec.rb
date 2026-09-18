require "spec_helper"

# The Integrator and Discussions SDKs both authenticate by asking the Core SDK for a
# JWT in their constructor. Only the Integrator path was exercised by the deploy that
# surfaced the authorization-code failure; both are covered here.
RSpec.describe "SDKs that authenticate through Core" do
  let(:token_response) do
    double("response", content: { "access_token" => "a-jwt", "token_type" => "Bearer" })
  end

  shared_examples "a client credentials consumer" do
    it "retrieves its jwt with the configured oauth client credentials" do
      expect_any_instance_of(KineticSdk::Core)
        .to receive(:jwt_token).with("a-client", "a-secret").and_return(token_response)

      expect(build_sdk.jwt).to eq("a-jwt")
    end

    it "asks a space scoped Core SDK for the token" do
      oauth_urls = []
      allow_any_instance_of(KineticSdk::Core).to receive(:jwt_token) do |core, *_args|
        oauth_urls << core.oauth_url
        token_response
      end

      build_sdk
      expect(oauth_urls).to eq(["https://acme.myapp.io/app/oauth2"])
    end

    it "propagates an authentication failure instead of continuing unauthenticated" do
      allow_any_instance_of(KineticSdk::Core)
        .to receive(:jwt_token).and_raise(StandardError, "Unable to retrieve token: 401 invalid_client")

      expect { build_sdk }.to raise_error(StandardError, /401 invalid_client/)
    end
  end

  def base_config
    {
      space_server_url: "https://acme.myapp.io",
      space_slug: "acme",
      username: "service-user",
      password: "service-password",
      options: {
        log_level: "off",
        oauth_client_id: "a-client",
        oauth_client_secret: "a-secret",
      },
    }
  end

  describe KineticSdk::Integrator do
    let(:build_sdk) { KineticSdk::Integrator.new(base_config) }
    it_behaves_like "a client credentials consumer"
  end

  describe KineticSdk::Discussions do
    let(:build_sdk) { KineticSdk::Discussions.new(base_config) }
    it_behaves_like "a client credentials consumer"
  end
end
