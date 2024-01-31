module KineticSdk
  class Core

    # Add a Submission
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param form_slug [String] slug of the Form
    # @param payload [Hash] payload of the submission
    #   - +origin+ - Origin ID of the submission to be added
    #   - +parent+ - Parent ID of the submission to be added
    #   - +values+ - hash of field values for the submission
    #     - attachment fields contain an Array of Hashes. Each hash represents an attachment answer for the field. The hash must include a `path` property with a value to represent the local file location.)
    # @param parameters [Hash] hash of query parameters to append to the URL
    #   - +include+ - comma-separated list of properties to include in the response
    #   - +completed+ - signals that the submission should be completed, default is false
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_submission(kapp_slug, form_slug, payload={}, parameters={}, headers=default_headers)
      # set origin hash if origin was passed as a string
      payload["origin"] = { "id" => payload["origin"] } if payload["origin"].is_a? String
      # set parent hash if parent was passed as a string
      payload["parent"] = { "id" => payload["parent"] } if payload["parent"].is_a? String
      # prepare any attachment values
      payload["values"] = prepare_new_submission_values(kapp_slug, form_slug, payload["values"])
      # build the uri with the encoded parameters
      uri = URI.parse("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}/submissions")
      uri.query = URI.encode_www_form(parameters) unless parameters.empty?
      # Create the submission
      @logger.info("Adding a submission in the \"#{form_slug}\" Form.")
      post(uri.to_s, payload, headers)
    end

    # Add a Submission page
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param form_slug [String] slug of the Form
    # @param page_name [String] name of the Page
    # @param payload [Hash] payload of the submission
    #   - +origin+ - Origin ID of the submission to be added
    #   - +parent+ - Parent ID of the submission to be added
    #   - +values+ - hash of field values for the submission
    #     - attachment fields contain an Array of Hashes. Each hash represents an attachment answer for the field. The hash must include a `path` property with a value to represent the local file location.)
    # @param parameters [Hash] hash of query parameters to append to the URL
    #   - +include+ - comma-separated list of properties to include in the response
    #   - +staged+ - Indicates whether field validations and page advancement should occur, default is false
    #   - +defer+ - Indicates the submission is for a subform embedded in a parent, default is false
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_submission_page(kapp_slug, form_slug, page_name, payload={}, parameters={}, headers=default_headers)
      # set origin hash if origin was passed as a string
      payload["origin"] = { "id" => payload["origin"] } if payload["origin"].is_a? String
      # set parent hash if parent was passed as a string
      payload["parent"] = { "id" => payload["parent"] } if payload["parent"].is_a? String
      # prepare any attachment values
      payload["values"] = prepare_new_submission_values(kapp_slug, form_slug, payload["values"])
      # add the page name to the parameters
      parameters["page"] = page_name
      # build the uri with the encoded parameters
      uri = URI.parse("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}/submissions")
      uri.query = URI.encode_www_form(parameters)
      # Create the submission
      @logger.info("Adding a submission page in the \"#{form_slug}\" Form.")
      post(uri.to_s, payload, headers)
    end

    # Delete a Submission
    #
    # @param submission_id [String] id of the Submission
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_submission(submission_id, headers=default_headers)
      @logger.info("Deleting a submission with id #{submission_id}.")
      delete("#{@api_url}/submissions/#{submission_id}", headers)
    end

    # Patch a new Submission
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param form_slug [String] slug of the Form
    # @param payload [Hash] payload of the submission
    #   - +origin+ - Origin ID of the submission to be patched
    #   - +parent+ - Parent ID of the submission to be patched
    #   - +values+ - hash of field values for the submission
    #     - attachment fields contain an Array of Hashes. Each hash represents an attachment answer for the field. The hash must include a `path` property with a value to represent the local file location.)
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def patch_new_submission(kapp_slug, form_slug, payload={}, headers=default_headers)
      # set the currentPage hash if currentPage was passed as a string
      payload["currentPage"] = { "name" => payload["currentPage"] } if payload["currentPage"].is_a? String
      # set origin hash if origin was passed as a string
      payload["origin"] = { "id" => payload["origin"] } if payload["origin"].is_a? String
      # set parent hash if parent was passed as a string
      payload["parent"] = { "id" => payload["parent"] } if payload["parent"].is_a? String
      # prepare any attachment values
      payload["values"] = prepare_new_submission_values(kapp_slug, form_slug, payload["values"])
      # Create the submission
      @logger.info("Patching a submission in the \"#{form_slug}\" Form.")
      patch("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}/submissions", payload, headers)
    end

    # Patch an existing Submission
    #
    # @param submission_id [String] id of the Submission
    # @param payload [Hash] payload of the submission
    #   - +origin+ - Origin ID of the submission to be patched
    #   - +parent+ - Parent ID of the submission to be patched
    #   - +values+ - hash of field values for the submission
    #     - attachment fields contain an Array of Hashes. Each hash represents an attachment answer for the field. The hash must include a `path` property with a value to represent the local file location.)
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def patch_existing_submission(submission_id, payload={}, headers=default_headers)
      # set the currentPage hash if currentPage was passed as a string
      payload["currentPage"] = { "name" => payload["currentPage"] } if payload["currentPage"].is_a? String
      # set origin hash if origin was passed as a string
      payload["origin"] = { "id" => payload["origin"] } if payload["origin"].is_a? String
      # set parent hash if parent was passed as a string
      payload["parent"] = { "id" => payload["parent"] } if payload["parent"].is_a? String
      # prepare any attachment values
      payload["values"] = prepare_updated_submission_values(submission_id, payload["values"])
      # Create the submission
      @logger.info("Patching a submission with id \"#{submission_id}\"")
      patch("#{@api_url}/submissions/#{submission_id}", payload, headers)
    end

    # Find all Submissions for a form.
    #
    # This method will process pages of form submissions and internally
    # concatenate the results into a single array.
    #
    # Warning - using this method can cause out of memory errors on large
    #           result sets.
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param form_slug [String] slug of the Form
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_all_form_submissions(kapp_slug, form_slug, params={}, headers=default_headers)
      @logger.info("Finding submissions for the \"#{form_slug}\" Form.")
      # Make the initial request of pages submissions
      response = find_form_submissions(kapp_slug, form_slug, params, headers)
      # Build the Messages Array
      messages = response.content["messages"]
      # Build Submissions Array
      submissions = response.content["submissions"]
      # if a next page token exists, keep retrieving submissions and add them to the results
      while (!response.content["nextPageToken"].nil?)
        params['pageToken'] = response.content["nextPageToken"]
        response = find_form_submissions(kapp_slug, form_slug, params, headers)
        # concat the messages
        messages.concat(response.content["messages"] || [])
        # concat the submissions
        submissions.concat(response.content["submissions"] || [])
      end
      final_content = { "messages" => messages, "submissions" => submissions, "nextPageToken" => nil }
      # Return the results
      response.content=final_content
      response.content_string=final_content.to_json
      response
    end

    # Find a page of Submissions for a form.
    #
    # The page offset can be defined by passing in the "pageToken" parameter,
    # indicating the value of the token that will represent the first
    # submission in the result set.  If not provided, the first page of
    # submissions will be retrieved.
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param form_slug [String] slug of the Form
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    #   - +pageToken+ - used for paginated results
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_form_submissions(kapp_slug, form_slug, params={}, headers=default_headers)
      # Get next page token
      token = params["pageToken"]
      if token.nil?
        @logger.info("Finding first page of submissions for the \"#{form_slug}\" Form.")
      else
        @logger.info("Finding page of submissions starting with token \"#{token}\" for the \"#{form_slug}\" Form.")
      end

      # Build Submission URL
      url = "#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}/submissions"
      # Return the response
      get(url, params, headers)
    end

    # Find a page of Submissions for a kapp.
    #
    # The page offset can be defined by passing in the "pageToken" parameter,
    # indicating the value of the token that will represent the first
    # submission in the result set.  If not provided, the first page of
    # submissions will be retrieved.
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    #   - +pageToken+ - used for paginated results
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_kapp_submissions(kapp_slug, params={}, headers=default_headers)
      # Get next page token
      token = params["pageToken"]
      if token.nil?
        @logger.info("Finding first page of submissions for the \"#{kapp_slug}\" Kapp.")
      else
        @logger.info("Finding page of submissions starting with token \"#{token}\" for the \"#{kapp_slug}\" Kapp.")
      end

      # Build Submission URL
      url = "#{@api_url}/kapps/#{kapp_slug}/submissions"
      # Return the response
      get(url, params, headers)
    end

    # Update a submission
    #
    # @param submission_id [String] String value of the Submission Id (UUID)
    # @param body [Hash] submission properties to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_submission(submission_id, body={}, headers=default_headers)
      @logger.info("Updating Submission \"#{submission_id}\"")
      put("#{@api_url}/submissions/#{encode(submission_id)}", body, headers)
    end

    private

    # Prepares new submission values for attachment fields
    #
    # @param kapp_slug [String] kapp slug
    # @param form_slug [String] form slug
    # @param values [Hash] hash of values being submitted
    # @return [Hash] hash of values with attachment paths replaced with uploaded file information
    def prepare_new_submission_values(kapp_slug, form_slug, values)
      file_upload_url = "#{@api_url.gsub('/app/api/v1','')}/#{kapp_slug}/#{form_slug}/files"
      prepare_submission_values(values, file_upload_url)
    end

    # Prepares updated submission values for attachment fields
    #
    # @param submission_id [String] id of the Submission
    # @param values [Hash] hash of values being submitted
    # @return [Hash] hash of values with attachment paths replaced with uploaded file information
    def prepare_updated_submission_values(submission_id, values)
      file_upload_url = "#{@api_url.gsub('/app/api/v1','')}/submissions/#{submission_id}/files"
      prepare_submission_values(values, file_upload_url)
    end

    # Prepares submission values for attachment fields
    #
    # @param values [Hash] hash of values being submitted
    # @param file_upload_url [String] url to post attachments
    # @return [Hash] hash of values with attachment paths replaced with uploaded file information
    def prepare_submission_values(values, file_upload_url)
      # initialize the values
      values = {} if values.nil?
      # handle attachment values
      values.each do |field, value|
        # if the value contains an array of files
        if value.is_a?(Array) && !value.empty? && value.first.is_a?(Hash) && value.first.has_key?('path')
          value.each_with_index do |file, index|
            # upload the file to the server
            file_upload_response = post_multipart(
              file_upload_url,
              { "package" => File.new(file['path']) },
              default_headers)
            # update the value with the file upload response
            if file_upload_response.status == 200
              values[field][index] = file_upload_response.content.first
            else
              raise "Attachment file upload failed: (#{file_upload_response.status}) #{file_upload_response.content_string}"
            end
          end
        end
      end
      # return the values
      values
    end

  end
end
