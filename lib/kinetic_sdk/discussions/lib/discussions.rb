module KineticSdk
  class Discussions

    # Add a Discussion
    #
    # @param properties [Hash] discussion properties
    #   - +title+ [String]
    #   - +description+ [String]
    #   - +joinPolicy+ [String] name of the security policy that defines who can join
    #   - +owningUsers+ [Array] array of user usernames
    #   - +owningTeams+ [Array] array of team names
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_discussion(properties={}, headers=default_jwt_headers)
      @logger.info("Adding the #{properties['title']} discussion")
      post("#{@api_url}/discussions", properties, headers)
    end

    # Delete a Discussion
    #
    # @param discussion_id [String] discussion_id of the discussion
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_discussion(discussion_id, headers=header_bearer_auth)
      @logger.info("Deleting Discussion \"#{discussion_id}\"")
      delete("#{@api_url}/discussions/#{discussion_id}", headers)
    end

    # Find Discussions
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_discussions(params={}, headers=default_jwt_headers)
      @logger.info("Finding Discussions.")
      get("#{@api_url}/discussions", params, headers)
    end

    # Find a Discussion
    #
    # @param discussion_id [String] id of the Discussion
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_discussion(discussion_id, params={}, headers=default_jwt_headers)
      @logger.info("Finding the \"#{discussion_id}\" Discussion.")
      get("#{@api_url}/discussions/#{discussion_id}", params, headers)
    end

    # Update a Discussion
    #
    # @param discussion_id [String] id of the Discussion
    # @param properties [Hash] form properties to update
    #   - +title+ [String]
    #   - +description+ [String]
    #   - +isArchived+ [Boolean]
    #   - +joinPolicy+ [String] name of the security policy that defines who can join
    #   - +owningUsers+ [Array] array of user usernames
    #   - +owningTeams+ [Array] array of team names
    # @param headers [Hash] hash of headers to send, default is bearer authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_discussion(discussion_id, properties={}, headers=default_jwt_headers)
      @logger.info("Updating the \"#{discussion_id}\" Discussion.")
      put("#{@api_url}/discussions/#{discussion_id}", properties, headers)
    end

    # Export all discussion attachments
    #
    # This method streams the attachments in chunks to avoid consuming large
    # amounts of memory.
    #
    # The message attachments will be saved to the 
    # `{export_directory}/{discussion_id}/files/{message_id}` directory, where:
    #
    #   * +export_directory+: the directory specified in the SDK configuration
    #   * +discussion_id+: the id of the discussion
    #   * +message_id+: the id of the message that contains the attachment
    #
    # @param discussion_id [String] id of the discussion
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is bearer authentication
    def export_discussion_attachments(discussion_id, params={}, headers=header_bearer_auth)
      raise StandardError.new "An export directory must be defined to export a file attachment." if @options[:export_directory].nil?
      @logger.info("Exporting all file attachments in the #{discussion_id} Discussion.")
      @logger.info("This may take a while.")
      # File Counter
      counter = 0
      # write the files
      find_messages(discussion_id, params, headers).content['messages'].each do |m|
        message_id = m['id']
        updated_at = m['updatedAt']
        m['content'].each do |item|
          if (item['type'] == "attachment")
            document_id = item['value']['documentId']
            filename = item['value']['filename']
            # count the files
            counter = counter + 1
            # export the file attachments
            export_message_attachment(discussion_id, message_id, document_id, filename, params, headers)
          end
        end
      end
      @logger.info("Exported #{counter} file attachments for the #{discussion_id} Discussion")
    end 

  end
end
