require 'base64'
require 'erb'
require 'mime/types'
require 'net/http'
require 'net/http/post/multipart'
require 'openssl'

require File.join(File.dirname(File.expand_path(__FILE__)), "kinetic-http-headers.rb")
require File.join(File.dirname(File.expand_path(__FILE__)), "kinetic-http-response.rb")

# The KineticSdk module contains functionality to interact with Kinetic Data applications
# using their built-in REST APIs.
module KineticSdk

  # A utilities module that can be used by multiple libraries.
  module Utils

    # The KineticHttpUtils module provides common HTTP methods, and returns a 
    # {KineticSdk::Utils::KineticHttpResponse} object with all methods. The raw 
    # Net::HTTPResponse is available by calling the 
    # {KineticSdk::Utils::KineticHttpResponse#response} method.
    module KineticHttpUtils

      # Include the Logger module
      include KineticSdk::Utils::Logger

      # Send an HTTP DELETE request
      # 
      # @param url [String] url to send the request to
      # @param headers [Hash] hash of headers to send
      # @param redirect_limit [Fixnum] max number of times to redirect
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def delete(url, headers={}, redirect_limit=max_redirects)
        # parse the URL
        uri = URI.parse(url)

        debug("DELETE #{uri}  #{headers.inspect}")

        # build the http object
        http = build_http(uri)
        # build the request
        request = Net::HTTP::Delete.new(uri.request_uri, headers)

        # send the request
        begin
          response = http.request(request)
          # handle the response
          case response
          when Net::HTTPRedirection then
            if redirect_limit == -1
              info("HTTP response code: #{response.code}") unless trace?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              delete_raw(response['location'], headers, redirect_limit - 1)
            end
          when NilClass then
            info("HTTP response code: 0") unless trace?
            raise Net::HTTPFatalError.new("No response from server", response)
          else
            info("HTTP response code: #{response.code}") unless trace?
            KineticHttpResponse.new(response)
          end
        rescue StandardError => e
          info("HTTP response: #{response.inspect}") unless trace?
          KineticHttpResponse.new(e)
        end
      end

      # Send an HTTP GET request
      # 
      # @param url [String] url to send the request to
      # @param params [Hash] Query parameters that are added to the URL, such as +include+
      # @param headers [Hash] hash of headers to send
      # @param redirect_limit [Fixnum] max number of times to redirect
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def get(url, params={}, headers={}, redirect_limit=max_redirects)
        # parse the URL
        uri = URI.parse(url)
        # add URL parameters
        uri.query = URI.encode_www_form(params)

        debug("GET #{uri}  #{headers.inspect}")

        # build the http object
        http = build_http(uri)
        # build the request
        request = Net::HTTP::Get.new(uri.request_uri, headers)

        # send the request
        begin
          response = http.request(request)
          # handle the response
          case response
          when Net::HTTPRedirection then
            if redirect_limit == -1
              info("HTTP response code: #{response.code}") unless trace?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              get_raw(response['location'], params, headers, redirect_limit - 1)
            end
          when NilClass then
            info("HTTP response code: 0") unless trace?
            raise Net::HTTPFatalError.new("No response from server", response)
          else
            info("HTTP response code: #{response.code}") unless trace?
            KineticHttpResponse.new(response)
          end
        rescue StandardError => e
          info("HTTP response: #{response.inspect}") unless trace?
          KineticHttpResponse.new(e)
        end
      end

      # Send an HTTP HEAD request
      # 
      # @param url [String] url to send the request to
      # @param params [Hash] Query parameters that are added to the URL, such as +include+
      # @param headers [Hash] hash of headers to send
      # @param redirect_limit [Fixnum] max number of times to redirect
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def head(url, params={}, headers={}, redirect_limit=max_redirects)
        # parse the URL
        uri = URI.parse(url)
        # add URL parameters
        uri.query = URI.encode_www_form(params)

        debug("HEAD #{uri}  #{headers.inspect}")

        # build the http object
        http = build_http(uri)
        # build the request
        request = Net::HTTP::Head.new(uri.request_uri, headers)

        # send the request
        begin
          response = http.request(request)
          # handle the response
          case response
          when Net::HTTPRedirection then
            if redirect_limit == -1
              info("HTTP response code: #{response.code}") unless trace?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              head_raw(response['location'], params, headers, redirect_limit - 1)
            end
          when NilClass then
            info("HTTP response code: 0") unless trace?
            raise Net::HTTPFatalError.new("No response from server", response)
          else
            info("HTTP response code: #{response.code}") unless trace?
            KineticHttpResponse.new(response)
          end
        rescue StandardError => e
          info("HTTP response: #{response.inspect}") unless trace?
          KineticHttpResponse.new(e)
        end
      end

      # Send an HTTP PATCH request
      # 
      # @param url [String] url to send the request to
      # @param data [Hash] the payload to send with the request
      # @param headers [Hash] hash of headers to send
      # @param redirect_limit [Fixnum] max number of times to redirect
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def patch(url, data={}, headers={}, redirect_limit=max_redirects)
        # parse the URL
        uri = URI.parse(url)

        debug("PATCH #{uri}  #{headers.inspect}")

        # unless the data is already a string, assume JSON and convert to string
        data = data.to_json unless data.is_a? String
        # build the http object
        http = build_http(uri)
        # build the request
        request = Net::HTTP::Patch.new(uri.request_uri, headers)
        request.body = data

        # send the request
        begin
          response = http.request(request)
          # handle the response
          case response
          when Net::HTTPRedirection then
            if redirect_limit == -1
              info("HTTP response code: #{response.code}") unless trace?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              patch_raw(response['location'], data, headers, redirect_limit - 1)
            end
          when NilClass then
            info("HTTP response code: 0") unless trace?
            raise Net::HTTPFatalError.new("No response from server", response)
          else
            info("HTTP response code: #{response.code}") unless trace?
            KineticHttpResponse.new(response)
          end
        rescue StandardError => e
          info("HTTP response: #{response.inspect}") unless trace?
          KineticHttpResponse.new(e)
        end
      end

      # Send an HTTP POST request
      # 
      # @param url [String] url to send the request to
      # @param data [Hash] the payload to send with the request
      # @param headers [Hash] hash of headers to send
      # @param redirect_limit [Fixnum] max number of times to redirect
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def post(url, data={}, headers={}, redirect_limit=max_redirects)
        # parse the URL
        uri = URI.parse(url)

        debug("POST #{uri}  #{headers.inspect}")

        # unless the data is already a string, assume JSON and convert to string
        data = data.to_json unless data.is_a? String
        # build the http object
        http = build_http(uri)
        # build the request
        request = Net::HTTP::Post.new(uri.request_uri, headers)
        request.body = data

        # send the request
        begin
          response = http.request(request)
          # handle the response
          case response
          when Net::HTTPRedirection then
            if redirect_limit == -1
              info("HTTP response code: #{response.code}") unless trace?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              post_raw(response['location'], data, headers, redirect_limit - 1)
            end
          when NilClass then
            info("HTTP response code: 0") unless trace?
            raise Net::HTTPFatalError.new("No response from server", response)
          else
            info("HTTP response code: #{response.code}") unless trace?
            KineticHttpResponse.new(response)
          end
        rescue StandardError => e
          info("HTTP response: #{response.inspect}") unless trace?
          KineticHttpResponse.new(e)
        end
      end

      # Send a Multipart HTTP POST request
      # 
      # @param url [String] url to send the request to
      # @param data [Hash] payload to send with the request
      # @param headers [Hash] hash of headers to send
      # @param redirect_limit [Fixnum] max number of times to redirect
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def post_multipart(url, data={}, headers={}, redirect_limit=max_redirects)
        # the Content-Type header is handled automoatically by Net::HTTP::Post::Multipart
        headers.delete_if { |k,v| k.to_s.downcase == "content-type" }

        debug("POST #{url}  #{headers.inspect}  multi-part form content")

        # parse the URL
        uri = URI.parse(url)

        # prepare the payload
        payload = data.inject({}) do |h,(k,v)| 
          if v.class == File
            h[k] = UploadIO.new(v, mimetype(v), File.basename(v))
          elsif v.class == Array
            # f = v.first
            # h[k] = UploadIO.new(f, mimetype(f), File.basename(f)) unless f.nil?
            h[k] = v.inject([]) do |files, part|
              if part.class == File
                files << UploadIO.new(part, mimetype(part), File.basename(part))
              end
            end
          else
            h[k] = v
          end
          h
        end

        # build the http object
        http = build_http(uri)
        # build the request
        request = Net::HTTP::Post::Multipart.new(uri.request_uri, payload)
        headers.each { |k,v| request.add_field(k, v) }
        # send the request
        begin
          response = http.request(request)
          # handle the response
          case response
          when Net::HTTPRedirection then
            if redirect_limit == -1
              info("HTTP response code: #{response.code}") unless trace?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              post_multipart_raw(response['location'], data, headers, redirect_limit - 1)
            end
          when NilClass then
            info("HTTP response code: 0") unless trace?
            raise Net::HTTPFatalError.new("No response from server", response)
          else
            info("HTTP response code: #{response.code}") unless trace?
            KineticHttpResponse.new(response)
          end
        rescue StandardError => e
          info("HTTP response: #{response.inspect}") unless trace?
          KineticHttpResponse.new(e)
        end
      end

      # Send an HTTP PUT request
      # 
      # @param url [String] url to send the request to
      # @param data [Hash] payload to send with the request
      # @param headers [Hash] hash of headers to send
      # @param redirect_limit [Fixnum] max number of times to redirect
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def put(url, data={}, headers={}, redirect_limit=max_redirects)
        # parse the URL
        uri = URI.parse(url)

        debug("PUT #{uri}  #{headers.inspect}")

        # unless the data is already a string, assume JSON and convert to string
        data = data.to_json unless data.is_a? String
        # build the http object
        http = build_http(uri)
        # build the request
        request = Net::HTTP::Put.new(uri.request_uri, headers)
        request.body = data

        # send the request
        begin
          response = http.request(request)
          # handle the response
          case response
          when Net::HTTPRedirection then
            if redirect_limit == -1
              info("HTTP response code: #{response.code}") unless trace?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              put_raw(response['location'], data, headers, redirect_limit - 1)
            end
          when NilClass then
            info("HTTP response code: 0") unless trace?
            raise Net::HTTPFatalError.new("No response from server", response)
          else
            info("HTTP response code: #{response.code}") unless trace?
            KineticHttpResponse.new(response)
          end
        rescue StandardError => e
          info("HTTP response: #{response.inspect}") unless trace?
          KineticHttpResponse.new(e)
        end
      end

      # Determine the final redirect location
      # 
      # @param url [String] url to send the request to
      # @param params [Hash] Query parameters that are added to the URL, such as +include+
      # @param headers [Hash] hash of headers to send
      # @param redirect_limit [Fixnum] max number of times to redirect
      # @return [String] redirection url, or url if there is no redirection
      def redirect_url(url, params={}, headers={}, redirect_limit=max_redirects)
        # parse the URL
        uri = URI.parse(url)
        # add URL parameters
        uri.query = URI.encode_www_form(params)

        # build the http object
        http = build_http(uri)
        # build the request
        request = Net::HTTP::Head.new(uri.request_uri, headers)

        # send the request
        response = http.request(request)
        # handle the response
        case response
        when Net::HTTPRedirection then
          if redirect_limit > 0
            url = response['location']
            head_raw(response['location'], params, headers, redirect_limit - 1)
          end
        end
        url
      end

      # Download attachment from a URL and save to file.
      #
      # Streams the download to limit memory consumption. The user account
      # utilizing the SDK must have write access to the file path.
      # 
      # @param url [String] url to send the request to
      # @param params [Hash] Query parameters that are added to the URL, such as +include+
      # @param headers [Hash] hash of headers to send
      # @param redirect_limit [Fixnum] max number of times to redirect
      def stream_download_to_file(file_path, url, params={}, headers={}, redirect_limit=max_redirects)
        # Determine if redirection is involved
        url = redirect_url(url, params, headers, max_redirects)
        # parse the URL
        uri = URI.parse(url)
  
        debug("Streaming Download #{uri}  #{headers.inspect}")
  
        # build the http object
        http = build_http(uri)
  
        # stream the attachment
        file = File.open(file_path, "wb")
        file_name = File.basename(file_path)
        response_code = nil
        message = nil
        begin
          http.request_get(uri.request_uri, headers) do |response|
            response_code = response.code
            if response_code == "200"
              response.read_body { |chunk| file.write(chunk) }
            else
              message = response.body
              break
            end
          end
          if response_code == "200"
            info("Exported file attachment: #{file_name} to #{file_path}")
          else
            warn("Failed to export file attachment \"#{file_name}\": #{message}")
          end
        rescue StandardError => e
          warn("Failed to export file attachment \"#{file_name}\": (#{e})")
        ensure
          file.close()
        end
      end
  
      # alias methods to allow wrapper modules to handle the
      # response object.
      alias_method :delete_raw, :delete
      alias_method :get_raw, :get
      alias_method :head_raw, :head
      alias_method :patch_raw, :patch
      alias_method :post_raw, :post
      alias_method :post_multipart_raw, :post_multipart
      alias_method :put_raw, :put


      # Encode URI components
      #
      # @param parameter [String] parameter value to encode
      # @return [String] URL encoded parameter value
      def encode(parameter)
        ERB::Util.url_encode parameter
      end

      # Determines the mime-type of a file
      # 
      # @param file [File | String] file or filename to detect
      # @return [Array] MIME::Type of the file
      def mimetype(file)
        mime_type = MIME::Types.type_for(file.class == File ? File.basename(file) : file)
        if mime_type.size == 0
          mime_type = MIME::Types['text/plain'] 
        end
        mime_type
      end

      # The maximum number of times to follow redirects.
      #
      # Can be passed in as an option when initializing the SDK
      # with either the @options[:max_redirects] or @options['max_redirects']
      # key.
      #
      # Expects an integer [Fixnum] value. Setting to 0 will disable redirects.
      #
      # @return [Fixnum] default 5
      def max_redirects
        limit = @options &&
        (
          @options[:max_redirects] ||
          @options['max_redirects']
        )
        limit.nil? ? 5 : limit.to_i
      end

      private

      # Build the Net::HTTP object.
      #
      # @param uri [URI] the URI for the HTTP request
      # @return [Net::HTTP]
      def build_http(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.set_debug_output($stdout) if trace?
        if (uri.scheme == 'https')
          http.use_ssl = true
          if (@options[:ssl_verify_mode].to_s.strip.downcase == 'peer')
            http.verify_mode = OpenSSL::SSL::VERIFY_PEER
            http.ca_file = @options[:ssl_ca_file] if @options[:ssl_ca_file]
          else
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
        end
        http.read_timeout=60
        http.open_timeout=60
        http
      end

    end


    # The KineticHttp class provides functionality to make generic HTTP requests.
    class KineticHttp

      include KineticSdk::Utils::KineticHttpUtils

      # The username used in the Basic Authentication header
      attr_reader :username
      # The password used in the Basic Authentication header
      attr_reader :password

      # Constructor
      #
      # @param username [String] username for Basic Authentication
      # @param password [String] password for Basic Authentication
      def initialize(username=nil, password=nil)
        @username = username
        @password = password
        @options = {}
      end

    end
    

  end
end
