module KineticSdk
  class Task

    # Add a group
    #
    # @param name [String] name of the group
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_group(name, headers=default_headers)
      @logger.info("Adding group \"#{name}\"")
      post("#{@api_url}/groups", { "name" => name }, headers)
    end

    # Delete a Group
    #
    # @param name [String] name of the group
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_group(name, headers=header_basic_auth)
      @logger.info("Deleting Group \"#{name}\"")
      delete("#{@api_url}/groups/#{encode(name)}", headers)
    end

    # Delete all Groups
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_groups(headers=header_basic_auth)
      @logger.info("Deleting all groups")
      (find_groups(headers).content['groups'] || []).each do |group|
        delete("#{@api_url}/groups/#{encode(group['name'])}", headers)
      end
    end

    # Export a Group
    #
    # @param group [String] name of the group
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def export_group(group, headers=header_basic_auth)
      raise StandardError.new "An export directory must be defined to export a group." if @options[:export_directory].nil?
      if group.is_a? String
        response = find_group(group, {}, headers)
        group = response.content
      end
      @logger.info("Exporting group \"#{group['name']}\" to #{@options[:export_directory]}.")
      # Create the groups directory if it doesn't yet exist
      group_dir = FileUtils::mkdir_p(File.join(@options[:export_directory], "groups"))
      group_file = File.join(group_dir, "#{group['name'].slugify}.json")
      # write the file
      responseObj = get("#{@api_url}/groups/#{encode(group['name'])}", {}, headers)
      File.write(group_file, JSON.pretty_generate(responseObj.content))
      @logger.info("Exported group: #{group['name']} to #{group_file}")
    end

    # Export Groups
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return nil
    def export_groups(headers=header_basic_auth)
      raise StandardError.new "An export directory must be defined to export groups." if @options[:export_directory].nil?
      (find_groups.content["groups"] || []).each do |group|
        export_group(group)
      end
    end

    # Import Groups
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return nil
    def import_groups(headers=default_headers)
      raise StandardError.new "An export directory must be defined to import groups from." if @options[:export_directory].nil?
      @logger.info("Importing all Groups in Export Directory")
      Dir["#{@options[:export_directory]}/groups/*.json"].sort.each do |file|
        group = JSON.parse(File.read(file))
        add_group(group["name"], headers)
      end
    end

    # Find all groups
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_groups(params={}, headers=header_basic_auth)
      @logger.info("Finding all groups")
      get("#{@api_url}/groups", params, headers)
    end

    # Find Group
    #
    # @param name [String] name of the group
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_group(name, params={}, headers=header_basic_auth)
      @logger.info("Finding the #{name} group")
      get("#{@api_url}/groups/#{encode(name)}", params, headers)
    end

    # Add user to group
    #
    # @param login_id [String] login id of the user
    # @param group_name [String] name of the group
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_user_to_group(login_id, group_name, headers=default_headers)
      body = { "loginId" => login_id }
      @logger.info("Adding user \"#{login_id}\" to group \"#{group_name}\"")
      post("#{@api_url}/groups/#{encode(group_name)}/users", body, headers)
    end

    # Remove user from group
    #
    # @param login_id [String] login id of the user
    # @param group_name [String] name of the group
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def remove_user_from_group(login_id, group_name, headers=default_headers)
      @logger.info("Removing user \"#{login_id}\" from group \"#{group_name}\"")
      post("#{@api_url}/groups/#{encode(group_name)}/users/#{encode(login_id)}", headers)
    end

  end
end
