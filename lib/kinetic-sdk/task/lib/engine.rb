module KineticSdk
  class Task

    # Start the task engine
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def start_engine(headers=default_headers)
      body = { "action" => "start" }
      response = post("#{@api_url}/engine", body, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Stop the task engine
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def stop_engine(headers=default_headers)
      body = { "action" => "stop" }
      response = post("#{@api_url}/engine", body, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Get the engine info
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def engine_info(params={}, headers=header_basic_auth)
      response = get("#{@api_url}/engine", params, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Get the engine status
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def engine_status(headers=header_basic_auth)
      response = engine_info({}, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
      data = response.content
      data.nil? ? "Unknown" : data['status']
    end

  end
end
