require "spec_helper"

# header_basic_auth is shared by ~85 call sites across the Task, Core, Bridgehub, Filehub
# and Agent SDKs, all of them ordinary HTTP Basic USER authentication (RFC 7617).
#
# Core authenticates those with Spring Security's BasicAuthenticationConverter, which
# base64-decodes and splits on ":" and does NOT URL-decode. OAuth2 client authentication
# is the odd one out: ClientSecretBasicAuthenticationConverter calls URLDecoder.decode on
# both values, per RFC 6749 section 2.3.1.
#
# Adding form encoding here to fix OAuth would therefore break every user whose password
# contains "+" or "%". The OAuth path avoids the header entirely and uses
# client_secret_post instead; see KineticSdk::Core#jwt_token.
RSpec.describe "KineticSdk::Utils::KineticHttpUtils header helpers" do
  let(:headers) do
    Class.new do
      include KineticSdk::Utils::KineticHttpUtils
    end.new
  end

  def decode(header)
    Base64.decode64(header["Authorization"].sub("Basic ", ""))
  end

  describe "#header_basic_auth" do
    it "sends credentials raw, without url encoding" do
      expect(decode(headers.header_basic_auth("user", "pass+word"))).to eq("user:pass+word")
    end

    {
      "plus" => "pass+word",
      "percent" => "pass%word",
      "space" => "pass word",
      "ampersand" => "pass&word",
      "percent two five" => "pass%25word",
    }.each do |name, password|
      it "leaves a password containing a #{name} untouched" do
        expect(decode(headers.header_basic_auth("user", password))).to eq("user:#{password}")
      end
    end

    it "produces a single line header" do
      long = "u" * 40
      expect(headers.header_basic_auth(long, long)["Authorization"]).not_to include("\n")
    end
  end
end
