module KineticSdk
  class Task

    # Complete a Deferred Task
    #
    # @param source_name [String] - name of the source
    # @param body [Hash] properties that are sent to update the task
    #   - +token+ - the token linked to the deferred task
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def complete_deferred_task(source_name, body, headers=default_headers)
      info("Completing deferred task for the \"#{source_name}\" Source.")
      response = post("#{@api_v1_url}/complete-deferred-task/#{encode(source_name)}", body, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
      response
    end

  end
end
