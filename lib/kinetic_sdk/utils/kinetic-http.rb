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

      # Send an HTTP DELETE request
      # 
      # @param url [String] url to send the request to
      # @param headers [Hash] hash of headers to send
      # @param http_options [Hash] hash of http options
      # @option http_options [Fixnum] :max_redirects optional - max number of times to redirect
      # @option http_options [Fixnum] :gateway_retry_limit optional - max number of times to retry a bad gateway
      # @option http_options [Float] :gateway_retry_delay optional - number of seconds to delay before retrying a bad gateway
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def delete(url, headers={}, http_options=@options)
        # determine the http options
        redirect_limit = http_options[:max_redirects] || max_redirects
        gateway_retries = http_options[:gateway_retry_limit] || gateway_retry_limit
        gateway_delay = http_options[:gateway_retry_delay] || gateway_retry_delay

        # parse the URL
        uri = URI.parse(url)

        @logger.debug("DELETE #{uri}  #{headers.inspect}")

        # build the http object
        http = build_http(uri)
        # build the request
        request = Net::HTTP::Delete.new(uri.request_uri, headers)

        # send the request
        begin
          response = http.request(request)
          # handle the response
          case response
          # handle 302
          when Net::HTTPRedirection then
            if redirect_limit == -1
              @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              delete(response['location'], headers, http_options.merge({
                :max_redirects => redirect_limit - 1
              }))
            end
          # handle 502, 503, 504
          when Net::HTTPBadGateway, Net::HTTPServiceUnavailable, Net::HTTPGatewayTimeOut then
            if gateway_retries == -1
              KineticHttpResponse.new(response)
            elsif gateway_retries == 0
              @logger.info("HTTP response: #{response.code} #{response.message}") unless @logger.debug?
              raise Net::HTTPFatalError.new("#{response.code} #{response.message}", response)
            else
              @logger.info("#{response.code} #{response.message}, retrying in #{gateway_delay} seconds")
              sleep(gateway_delay)
              delete(url, headers, http_options.merge({
                :gateway_retry_limit => gateway_retries - 1
              }))
            end
          when Net::HTTPUnknownResponse, NilClass then
            @logger.info("HTTP response code: 0") unless @logger.debug?
            e = Net::HTTPFatalError.new("Unknown response from server", response)
            KineticHttpResponse.new(e)
          else
            @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
            KineticHttpResponse.new(response)
          end
        rescue Net::HTTPBadResponse => e
          @logger.info("HTTP bad response: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        rescue StandardError => e
          @logger.info("HTTP error: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        end
      end

      # Send an HTTP GET request
      # 
      # @param url [String] url to send the request to
      # @param params [Hash] Query parameters that are added to the URL, such as +include+
      # @param headers [Hash] hash of headers to send
      # @param http_options [Hash] hash of http options
      # @option http_options [Fixnum] :max_redirects optional - max number of times to redirect
      # @option http_options [Fixnum] :gateway_retry_limit optional - max number of times to retry a bad gateway
      # @option http_options [Float] :gateway_retry_delay optional - number of seconds to delay before retrying a bad gateway
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def get(url, params={}, headers={}, http_options=@options)
        # determine the http options
        redirect_limit = http_options[:max_redirects] || max_redirects
        gateway_retries = http_options[:gateway_retry_limit] || gateway_retry_limit
        gateway_delay = http_options[:gateway_retry_delay] || gateway_retry_delay

        # parse the URL
        uri = URI.parse(url)
        # add URL parameters
        uri.query = URI.encode_www_form(params)

        @logger.debug("GET #{uri}  #{headers.inspect}")

        # build the http object
        http = build_http(uri)
        # build the request
        request = Net::HTTP::Get.new(uri.request_uri, headers)

        # send the request
        begin
          response = http.request(request)
          # handle the response
          case response
          # handle 302
          when Net::HTTPRedirection then
            if redirect_limit == -1
              @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              get(response['location'], params, headers, http_options.merge({
                :max_redirects => redirect_limit - 1
              }))
            end
          # handle 502, 503, 504
          when Net::HTTPBadGateway, Net::HTTPServiceUnavailable, Net::HTTPGatewayTimeOut then
            if gateway_retries == -1
              KineticHttpResponse.new(response)
            elsif gateway_retries == 0
              @logger.info("HTTP response: #{response.code} #{response.message}") unless @logger.debug?
              raise Net::HTTPFatalError.new("#{response.code} #{response.message}", response)
            else
              @logger.info("#{response.code} #{response.message}, retrying in #{gateway_delay} seconds")
              sleep(gateway_delay)
              get(url, params, headers, http_options.merge({
                :gateway_retry_limit => gateway_retries - 1
              }))
            end
          when Net::HTTPUnknownResponse, NilClass then
            @logger.info("HTTP response code: 0") unless @logger.debug?
            e = Net::HTTPFatalError.new("Unknown response from server", response)
            KineticHttpResponse.new(e)
          else
            @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
            KineticHttpResponse.new(response)
          end
        rescue Net::HTTPBadResponse => e
          @logger.info("HTTP bad response: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        rescue StandardError => e
          @logger.info("HTTP error: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        end
      end

      # Send an HTTP HEAD request
      # 
      # @param url [String] url to send the request to
      # @param params [Hash] Query parameters that are added to the URL, such as +include+
      # @param headers [Hash] hash of headers to send
      # @param http_options [Hash] hash of http options
      # @option http_options [Fixnum] :max_redirects optional - max number of times to redirect
      # @option http_options [Fixnum] :gateway_retry_limit optional - max number of times to retry a bad gateway
      # @option http_options [Float] :gateway_retry_delay optional - number of seconds to delay before retrying a bad gateway
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def head(url, params={}, headers={}, http_options=@options)
        # determine the http options
        redirect_limit = http_options[:max_redirects] || max_redirects
        gateway_retries = http_options[:gateway_retry_limit] || gateway_retry_limit
        gateway_delay = http_options[:gateway_retry_delay] || gateway_retry_delay

        # parse the URL
        uri = URI.parse(url)
        # add URL parameters
        uri.query = URI.encode_www_form(params)

        @logger.debug("HEAD #{uri}  #{headers.inspect}")

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
              @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              head(response['location'], params, headers, http_options.merge({
                :max_redirects => redirect_limit - 1
              }))
            end
          # handle 502, 503, 504
          when Net::HTTPBadGateway, Net::HTTPServiceUnavailable, Net::HTTPGatewayTimeOut then
            if gateway_retries == -1
              KineticHttpResponse.new(response)
            elsif gateway_retries == 0
              @logger.info("HTTP response: #{response.code} #{response.message}") unless @logger.debug?
              raise Net::HTTPFatalError.new("#{response.code} #{response.message}", response)
            else
              @logger.info("#{response.code} #{response.message}, retrying in #{gateway_delay} seconds")
              sleep(gateway_delay)
              head(url, params, headers, http_options.merge({
                :gateway_retry_limit => gateway_retries - 1
              }))
            end
          when Net::HTTPUnknownResponse, NilClass then
            @logger.info("HTTP response code: 0") unless @logger.debug?
            e = Net::HTTPFatalError.new("Unknown response from server", response)
            KineticHttpResponse.new(e)
          else
            @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
            KineticHttpResponse.new(response)
          end
        rescue Net::HTTPBadResponse => e
          @logger.info("HTTP bad response: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        rescue StandardError => e
          @logger.info("HTTP error: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        end
      end

      # Send an HTTP PATCH request
      # 
      # @param url [String] url to send the request to
      # @param data [Hash] the payload to send with the request
      # @param headers [Hash] hash of headers to send
      # @param http_options [Hash] hash of http options
      # @option http_options [Fixnum] :max_redirects optional - max number of times to redirect
      # @option http_options [Fixnum] :gateway_retry_limit optional - max number of times to retry a bad gateway
      # @option http_options [Float] :gateway_retry_delay optional - number of seconds to delay before retrying a bad gateway
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def patch(url, data={}, headers={}, http_options=@options)
        # determine the http options
        redirect_limit = http_options[:max_redirects] || max_redirects
        gateway_retries = http_options[:gateway_retry_limit] || gateway_retry_limit
        gateway_delay = http_options[:gateway_retry_delay] || gateway_retry_delay

        # parse the URL
        uri = URI.parse(url)

        @logger.debug("PATCH #{uri}  #{headers.inspect}")

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
              @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              patch(response['location'], data, headers, http_options.merge({
                :max_redirects => redirect_limit - 1
              }))
            end
          # handle 502, 503, 504
          when Net::HTTPBadGateway, Net::HTTPServiceUnavailable, Net::HTTPGatewayTimeOut then
            if gateway_retries == -1
              KineticHttpResponse.new(response)
            elsif gateway_retries == 0
              @logger.info("HTTP response: #{response.code} #{response.message}") unless @logger.debug?
              raise Net::HTTPFatalError.new("#{response.code} #{response.message}", response)
            else
              @logger.info("#{response.code} #{response.message}, retrying in #{gateway_delay} seconds")
              sleep(gateway_delay)
              patch(url, data, headers, http_options.merge({
                :gateway_retry_limit => gateway_retries - 1
              }))
            end
          when Net::HTTPUnknownResponse, NilClass then
            @logger.info("HTTP response code: 0") unless @logger.debug?
            e = Net::HTTPFatalError.new("Unknown response from server", response)
            KineticHttpResponse.new(e)
          else
            @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
            KineticHttpResponse.new(response)
          end
        rescue Net::HTTPBadResponse => e
          @logger.info("HTTP bad response: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        rescue StandardError => e
          @logger.info("HTTP error: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        end
      end

      # Send an HTTP POST request
      # 
      # @param url [String] url to send the request to
      # @param data [Hash] the payload to send with the request
      # @param headers [Hash] hash of headers to send
      # @param http_options [Hash] hash of http options
      # @option http_options [Fixnum] :max_redirects optional - max number of times to redirect
      # @option http_options [Fixnum] :gateway_retry_limit optional - max number of times to retry a bad gateway
      # @option http_options [Float] :gateway_retry_delay optional - number of seconds to delay before retrying a bad gateway
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def post(url, data={}, headers={}, http_options=@options)
        # determine the http options
        redirect_limit = http_options[:max_redirects] || max_redirects
        gateway_retries = http_options[:gateway_retry_limit] || gateway_retry_limit
        gateway_delay = http_options[:gateway_retry_delay] || gateway_retry_delay

        # parse the URL
        uri = URI.parse(url)

        @logger.debug("POST #{uri}  #{headers.inspect}")

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
              @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              post(response['location'], data, headers, http_options.merge({
                :max_redirects => redirect_limit - 1
              }))
            end
          # handle 502, 503, 504
          when Net::HTTPBadGateway, Net::HTTPServiceUnavailable, Net::HTTPGatewayTimeOut then
            if gateway_retries == -1
              KineticHttpResponse.new(response)
            elsif gateway_retries == 0
              @logger.info("HTTP response: #{response.code} #{response.message}") unless @logger.debug?
              raise Net::HTTPFatalError.new("#{response.code} #{response.message}", response)
            else
              @logger.info("#{response.code} #{response.message}, retrying in #{gateway_delay} seconds")
              sleep(gateway_delay)
              post(url, data, headers, http_options.merge({
                :gateway_retry_limit => gateway_retries - 1
              }))
            end
          when Net::HTTPUnknownResponse, NilClass then
            @logger.info("HTTP response code: 0") unless @logger.debug?
            e = Net::HTTPFatalError.new("Unknown response from server", response)
            KineticHttpResponse.new(e)
          else
            @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
            KineticHttpResponse.new(response)
          end
        rescue Net::HTTPBadResponse => e
          @logger.info("HTTP bad response: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        rescue StandardError => e
          @logger.info("HTTP error: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        end
      end

      # Send a Multipart HTTP POST request
      # 
      # @param url [String] url to send the request to
      # @param data [Hash] payload to send with the request
      # @param headers [Hash] hash of headers to send
      # @param http_options [Hash] hash of http options
      # @option http_options [Fixnum] :max_redirects optional - max number of times to redirect
      # @option http_options [Fixnum] :gateway_retry_limit optional - max number of times to retry a bad gateway
      # @option http_options [Float] :gateway_retry_delay optional - number of seconds to delay before retrying a bad gateway
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def post_multipart(url, data={}, headers={}, http_options=@options)
        # determine the http options
        redirect_limit = http_options[:max_redirects] || max_redirects
        gateway_retries = http_options[:gateway_retry_limit] || gateway_retry_limit
        gateway_delay = http_options[:gateway_retry_delay] || gateway_retry_delay

        # the Content-Type header is handled automoatically by Net::HTTP::Post::Multipart
        headers.delete_if { |k,v| k.to_s.downcase == "content-type" }

        @logger.debug("POST #{url}  #{headers.inspect}  multi-part form content")

        # parse the URL
        uri = URI.parse(url)

        # prepare the payload
        payload = data.inject({}) do |h,(k,v)| 
          if v.class == File
            h[k] = UploadIO.new(v, mimetype(v).first, File.basename(v))
          elsif v.class == Array
            h[k] = v.inject([]) do |files, part|
              if part.class == File
                files << UploadIO.new(part, mimetype(part).first, File.basename(part))
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
              @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              post_multipart(response['location'], data, headers, http_options.merge({
                :max_redirects => redirect_limit - 1
              }))
            end
          # handle 502, 503, 504
          when Net::HTTPBadGateway, Net::HTTPServiceUnavailable, Net::HTTPGatewayTimeOut then
            if gateway_retries == -1
              KineticHttpResponse.new(response)
            elsif gateway_retries == 0
              @logger.info("HTTP response: #{response.code} #{response.message}") unless @logger.debug?
              raise Net::HTTPFatalError.new("#{response.code} #{response.message}", response)
            else
              @logger.info("#{response.code} #{response.message}, retrying in #{gateway_delay} seconds")
              sleep(gateway_delay)
              post_multipart(url, data, headers, http_options.merge({
                :gateway_retry_limit => gateway_retries - 1
              }))
            end
          when Net::HTTPUnknownResponse, NilClass then
            @logger.info("HTTP response code: 0") unless @logger.debug?
            e = Net::HTTPFatalError.new("Unknown response from server", response)
            KineticHttpResponse.new(e)
          else
            @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
            KineticHttpResponse.new(response)
          end
        rescue Net::HTTPBadResponse => e
          @logger.info("HTTP bad response: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        rescue StandardError => e
          @logger.info("HTTP error: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        end
      end

      # Send an HTTP PUT request
      # 
      # @param url [String] url to send the request to
      # @param data [Hash] payload to send with the request
      # @param headers [Hash] hash of headers to send
      # @param http_options [Hash] hash of http options
      # @option http_options [Fixnum] :max_redirects optional - max number of times to redirect
      # @option http_options [Fixnum] :gateway_retry_limit optional - max number of times to retry a bad gateway
      # @option http_options [Float] :gateway_retry_delay optional - number of seconds to delay before retrying a bad gateway
      # @return [KineticSdk::Utils::KineticHttpResponse] response
      def put(url, data={}, headers={}, http_options=@options)
        # determine the http options
        redirect_limit = http_options[:max_redirects] || max_redirects
        gateway_retries = http_options[:gateway_retry_limit] || gateway_retry_limit
        gateway_delay = http_options[:gateway_retry_delay] || gateway_retry_delay

        # parse the URL
        uri = URI.parse(url)

        @logger.debug("PUT #{uri}  #{headers.inspect}")

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
              @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
              KineticHttpResponse.new(response)
            elsif redirect_limit == 0
              raise Net::HTTPFatalError.new("Too many redirects", response)
            else
              put(response['location'], data, headers, http_options.merge({
                :max_redirects => redirect_limit - 1
              }))
            end
          # handle 502, 503, 504
          when Net::HTTPBadGateway, Net::HTTPServiceUnavailable, Net::HTTPGatewayTimeOut then
            if gateway_retries == -1
              KineticHttpResponse.new(response)
            elsif gateway_retries == 0
              @logger.info("HTTP response: #{response.code} #{response.message}") unless @logger.debug?
              raise Net::HTTPFatalError.new("#{response.code} #{response.message}", response)
            else
              @logger.info("#{response.code} #{response.message}, retrying in #{gateway_delay} seconds")
              sleep(gateway_delay)
              put(url, data, headers, http_options.merge({
                :gateway_retry_limit => gateway_retries - 1
              }))
            end
          when Net::HTTPUnknownResponse, NilClass then
            @logger.info("HTTP response code: 0") unless @logger.debug?
            e = Net::HTTPFatalError.new("Unknown response from server", response)
            KineticHttpResponse.new(e)
          else
            @logger.info("HTTP response code: #{response.code}") unless @logger.debug?
            KineticHttpResponse.new(response)
          end
        rescue Net::HTTPBadResponse => e
          @logger.info("HTTP bad response: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        rescue StandardError => e
          @logger.info("HTTP error: #{e.inspect}") unless @logger.debug?
          KineticHttpResponse.new(e)
        end
      end

      # Determine the final redirect location
      # 
      # @param url [String] url to send the request to
      # @param params [Hash] Query parameters that are added to the URL, such as +include+
      # @param headers [Hash] hash of headers to send
      # @param http_options [Hash] hash of http options
      # @option http_options [Fixnum] :max_redirects optional - max number of times to redirect
      # @option http_options [Fixnum] :gateway_retry_limit optional - max number of times to retry a bad gateway
      # @option http_options [Float] :gateway_retry_delay optional - number of seconds to delay before retrying a bad gateway
      # @return [String] redirection url, or url if there is no redirection
      def redirect_url(url, params={}, headers={}, http_options=@options)
        # determine the http options
        redirect_limit = http_options[:max_redirects] || max_redirects
        gateway_retries = http_options[:gateway_retry_limit] || gateway_retry_limit
        gateway_delay = http_options[:gateway_retry_delay] || gateway_retry_delay

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
            head(response['location'], params, headers, http_options.merge({
              :max_redirects => redirect_limit - 1
            }))
          end
        # handle 502, 503, 504
        when Net::HTTPBadGateway, Net::HTTPServiceUnavailable, Net::HTTPGatewayTimeOut then
          if gateway_retries == -1
            KineticHttpResponse.new(response)
          elsif gateway_retries == 0
              @logger.info("HTTP response: #{response.code} #{response.message}") unless @logger.debug?
            raise Net::HTTPFatalError.new("#{response.code} #{response.message}", response)
          else
            @logger.info("#{response.code} #{response.message}, retrying in #{gateway_delay} seconds")
            sleep(gateway_delay)
            redirect_url(url, params, headers, http_options.merge({
              :gateway_retry_limit => gateway_retries - 1
            }))
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
      # @param http_options [Hash] hash of http options
      # @option http_options [Fixnum] :max_redirects optional - max number of times to redirect
      # @option http_options [Fixnum] :gateway_retry_limit optional - max number of times to retry a bad gateway
      # @option http_options [Float] :gateway_retry_delay optional - number of seconds to delay before retrying a bad gateway
      def stream_download_to_file(file_path, url, params={}, headers={}, http_options=@options)
        # Determine if redirection is involved
        url = redirect_url(url, params, headers, http_options)
        # parse the URL
        uri = URI.parse(url)
  
        @logger.debug("Streaming Download #{uri}  #{headers.inspect}")
  
        # build the http object
        http = build_http(uri)
  
        # prepare the download
        file = nil
        file_name = File.basename(file_path)
        response_code = nil
        message = nil
        begin
          # stream the attachment
          http.request_get(uri.request_uri, headers) do |response|
            response_code = response.code
            if response_code == "200"
              file = File.open(file_path, "wb")
              response.read_body { |chunk| file.write(chunk) }
            else
              message = response.body
              break
            end
          end
          if response_code == "200"
            @logger.info("Exported file attachment: #{file_name} to #{file_path}")
          else
            @logger.error("Failed to export file attachment \"#{file_name}\": #{message}")
          end
        rescue StandardError => e
          @logger.error("Failed to export file attachment \"#{file_name}\": (#{e})")
        ensure
          file.close() unless file.nil?
        end
        message
      end


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

      # The maximum number of times to retry on a bad gateway response.
      #
      # Can be passed in as an option when initializing the SDK
      # with either the @options[:gateway_retry_limit] or 
      # @options['gateway_retry_limit'] key.
      #
      # Expects an integer [Fixnum] value. Setting to -1 will disable retries on
      # a bad gateway response.
      #
      # @return [Fixnum] default -1
      def gateway_retry_limit
        limit = @options &&
        (
          @options[:gateway_retry_limit] ||
          @options['gateway_retry_limit']
        )
        limit.nil? ? -1 : limit.to_i
      end

      # The amount of time in seconds to delay before retrying the request when
      # a bad gateway response is encountered.
      #
      # Can be passed in as an option when initializing the SDK
      # with either the @options[:gateway_retry_delay] or 
      # @options['gateway_retry_delay'] key.
      #
      # Expects a double [Float] value.
      #
      # @return [Float] default 1.0
      def gateway_retry_delay
        delay = @options &&
        (
          @options[:gateway_retry_delay] ||
          @options['gateway_retry_delay']
        )
        delay.nil? ? 1.0 : delay.to_f
      end


      private

      # Build the Net::HTTP object.
      #
      # @param uri [URI] the URI for the HTTP request
      # @return [Net::HTTP]
      def build_http(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.set_debug_output($stdout) if @logger.debug?
        if (uri.scheme == 'https')
          http.use_ssl = true
          OpenSSL.debug = @logger.debug?
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

    end # KineticSdk::Utils::KineticHttpUtils module


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
      # @param http_options [Hash] hash of http options
      # @option http_options [String] :log_level (off) log_level
      # @option http_options [Fixnum] :max_redirects (5) max number of times to redirect
      # @option http_options [Fixnum] :gateway_retry_limit (-1) max number of times to retry a bad gateway
      # @option http_options [Float] :gateway_retry_delay (1.0) number of seconds to delay before retrying a bad gateway
      # @option http_options [String] :ssl_ca_file (/etc/ca.crt certificate) location of the ca certificate
      # @option http_options [String] :ssl_verify_mode (none) use `peer` to enable verification
      def initialize(username=nil, password=nil, http_options={})
        @username = username
        @password = password
        @options = http_options
      end

    end # KineticSdk::Utils::KineticHttp class

  end # KineticSdk::Utils module

  # The CustomHttp class provides functionality to make generic HTTP requests
  # utilizing the functionality of the KineticSdk.
  class CustomHttp
    include KineticSdk::Utils::KineticHttpUtils
    attr_accessor :username, :password, :options, :logger

    # Constructor
    #
    # @param opts [Hash] options for HTTP requests
    # @option opts [String] :username (nil) for Basic Authentication
    # @option opts [String] :password (nil) for Basic Authentication
    # @option opts [Hash] :options ({}) http options
    # @option options [String] :log_level (off) log_level
    # @option options [String] :log_output (STDOUT) log_output
    # @option options [Fixnum] :max_redirects (5) max number of times to redirect
    # @option options [Fixnum] :gateway_retry_limit (-1) max number of times to retry a bad gateway
    # @option options [Float] :gateway_retry_delay (1.0) number of seconds to delay before retrying a bad gateway
    # @option options [String] :ssl_ca_file (/etc/ca.crt certificate) location of the ca certificate
    # @option options [String] :ssl_verify_mode (none) use `peer` to enable verification
    def initialize(opts={})
      @username = opts[:username]
      @password = opts[:password]
      @options = opts.delete(:options) || {}
      log_level = @options[:log_level] || @options["log_level"]
      log_output = @options[:log_output] || @options["log_output"]
      @logger = KineticSdk::Utils::KLogger.new(log_level, log_output)
    end

  end


end # KineticSdk module
