module KineticSdk
  class Task

    # Delete a Run.
    #
    # @param id the id of the run to delete
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     delete_run(24548)
    #
    def delete_run(id, headers=header_basic_auth)
      @logger.info("Deleting run \"#{id}\"")
      delete("#{@api_url}/runs/#{id}", headers)
    end

    # Find runs.
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     find_runs({ "source" => "Kinetic Request CE" })
    #
    # Example
    # 
    #     find_runs({ "include" => "details" })
    #
    # Example
    #
    #     find_runs({ "source" => "Kinetic Request CE", "include" => "details" })
    #
    def find_runs(params={}, headers=header_basic_auth)
      @logger.info("Finding Runs")
      get("#{@api_url}/runs", params, headers)
    end

  end
end
