module KineticSdk
  class Task

    # Add a source
    #
    # @param source [Hash] Source properties
    #   - +name+ - name of the source
    #   - +status+ - initial status of the source (Active | Inactive)
    #   - +type+ - name of one of the source consumers registered in the task engine
    #   - +properties+ - hash of properties specific to the source consumer
    #   - +policyRules+ - array of policy rules to associate with the source
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Example
    #
    #     add_source({
    #       "name" => "Source Name",
    #       "status" => "Active",
    #       "type" => "Kinetic Request CE",
    #       "properties" => {
    #         "Space Slug" => "foo",
    #         "Web Server" => "http://localhost:8080/kinetic",
    #         "Proxy Username" => "integration-user",
    #         "Proxy Password" => "integration-password"
    #       },
    #       "policyRules" => []
    #     })
    #
    def add_source(source, headers=default_headers)
      name = source['name']
      info("Adding the #{name} source")
      response = post("#{@api_url}/sources", source, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Delete a Source
    #
    # @param name [String] name of the source
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_source(name, headers=header_basic_auth)
      info("Deleting Source \"#{name}\"")
      response = delete("#{@api_url}/sources/#{encode(name)}", headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Delete all Sources
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_sources(headers=header_basic_auth)
      info("Deleting all sources")
      (find_sources(headers).content['sources'] || []).each do |source|
        response = delete("#{@api_url}/sources/#{encode(source['name'])}", headers)
        if @options[:raise_exceptions] && [200].include?(response.status) == false
          raise "#{response.status} #{response.message}"
        end
      end
    end

    # Find all sources
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_sources(params={}, headers=header_basic_auth)
      info("Finding all sources")
      response = get("#{@api_url}/sources", params, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Find a source
    #
    # @param name [String] name of the source
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_source(name, params={}, headers=header_basic_auth)
      info("Finding source named \"#{name}\"")
      response = get("#{@api_url}/sources/#{encode(name)}", params, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Update a source
    #
    # @param source [Hash] hash of existing source properties that must contain 'name'
    #   - +name+ - name of the source
    # @param body [Hash] - source properties to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    #
    # Exammple
    #
    #     update_source(
    #       { "name" => "Kinetic Request CE" },
    #       {
    #         "name": "Possible New Source Name",
    #         "status": "Active|Unconfigured",
    #         "type": "Adhoc|...",
    #         "properties": {},
    #         "policyRules": [
    #           { "type": "API Access", "name": "Super User" },
    #           { "type": "API Access", "name": "Info User" },
    #           { "type": "Console Access", "name": "Super User" }
    #         ]
    #       }
    #     )
    #
    def update_source(source, body={}, headers=default_headers)
      info("Updating the \"#{source['name']}\" Source")
      response = put("#{@api_url}/sources/#{encode(source['name'])}", body, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Add policy rule to source
    #
    # @param policy_rule_type [String] the type of policy rule
    # @param policy_rule_name [String] the name of the policy rule
    # @param source_name [String] name of the source to add the policy rule to
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_policy_rule_to_source(policy_rule_type, policy_rule_name, source_name, headers=default_headers)
      body = { "type" => policy_rule_type, "name" => policy_rule_name }
      info("Adding policy rule \"#{policy_rule_type} - #{policy_rule_name}\" to source \"#{source_name}\"")
      response = post("#{@api_url}/sources/#{encode(source_name)}/policyRules", body, headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

    # Remove policy rule from source
    #
    # @param policy_rule_type [String] the type of policy rule
    # @param policy_rule_name [String] the name of the policy rule
    # @param source_name [String] name of the source to add the policy rule to
    # @param headers [Hash] hash of headers to send, default is basic authentication and JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def remove_policy_rule_from_source(policy_rule_type, policy_rule_name, source_name, headers=default_headers)
      info("Removing policy rule \"#{policy_rule_type} - #{policy_rule_name}\" from source \"#{source_name}\"")
      response = delete("#{@api_url}/sources/#{encode(source_name)}/policyRules/#{encode(policy_rule_type)}/#{encode(policy_rule_name)}", headers)
      if @options[:raise_exceptions] && [200].include?(response.status) == false
        raise "#{response.status} #{response.message}"
      end
    end

  end
end
