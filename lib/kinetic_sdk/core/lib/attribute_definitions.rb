module KineticSdk
  class Core

    # Add a new datastore form attribute definition.
    #
    # @param name [String] name of the attribute definition
    # @param description [String] description of the attribute definition
    # @param allows_multiple [Boolean] whether the attribute allows multiple values
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_datastore_form_attribute_definition(name, description, allows_multiple, headers=default_headers)
      body = {
        "allowsMultiple" => allows_multiple,
        "description" => description,
        "name" => name
      }
      @logger.info("Adding Datastore Form attribute definition \"#{name}\" to the \"#{space_slug}\" space.")
      # Create the attribute definition
      post("#{@api_url}/datastoreFormAttributeDefinitions", body, headers)
    end

    # Delete a datastore form attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_datastore_form_attribute_definition(name, headers=default_headers)
      @logger.info("Deleting the \"#{name}\" Datastore Form Attribute Definition")
      delete("#{@api_url}/datastoreFormAttributeDefinitions/#{encode(name)}", headers)
    end

    # Find a datastore form attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_datastore_form_attribute_definition(name, params={}, headers=default_headers)
      @logger.info("Finding the \"#{name}\" Datastore Form Attribute Definition")
      get("#{@api_url}/datastoreFormAttributeDefinitions/#{encode(name)}", params, headers)
    end

    # Find all datastore form attribute definitions
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_datastore_form_attribute_definitions(params={}, headers=default_headers)
      @logger.info("Finding Datastore Form Attribute Definitions")
      get("#{@api_url}/datastoreFormAttributeDefinitions", params, headers)
    end

    # Update a datastore form attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param body [Hash] properties of the attribute definition to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_datastore_form_attribute_definition(name, body={}, headers=default_headers)
      @logger.info("Updating the \"#{name}\" Datastore Form Attribute Definition.")
      put("#{@api_url}/datastoreFormAttributeDefinitions/#{encode(name)}",body, headers)
    end

    # Add a new space attribute definition.
    #
    # @param name [String] name of the attribute definition
    # @param description [String] description of the attribute definition
    # @param allows_multiple [Boolean] whether the attribute allows multiple values
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_space_attribute_definition(name, description, allows_multiple, headers=default_headers)
      body = {
        "allowsMultiple" => allows_multiple,
        "description" => description,
        "name" => name
      }
      @logger.info("Adding Space attribute definition \"#{name}\" to the \"#{space_slug}\" space.")
      # Create the attribute definition
      post("#{@api_url}/spaceAttributeDefinitions", body, headers)
    end

    # Delete a space attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_space_attribute_definition(name, headers=default_headers)
      @logger.info("Deleting the \"#{name}\" Space Attribute Definition")
      delete("#{@api_url}/spaceAttributeDefinitions/#{encode(name)}", headers)
    end

    # Find a space attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_space_attribute_definition(name, params={}, headers=default_headers)
      @logger.info("Finding the \"#{name}\" Space Attribute Definition")
      get("#{@api_url}/spaceAttributeDefinitions/#{encode(name)}", params, headers)
    end

    # Find all space attribute definitions
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_space_attribute_definitions(params={}, headers=default_headers)
      @logger.info("Finding Space Attribute Definitions")
      get("#{@api_url}/spaceAttributeDefinitions", params, headers)
    end

    # Update a space attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param body [Hash] properties of the attribute definition to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_space_attribute_definition(name, body, headers=default_headers)
      @logger.info("Updating the \"#{name}\" Space Attribute Definition.")
      put("#{@api_url}/spaceAttributeDefinitions/#{encode(name)}",body, headers)
    end

    # Add a new team attribute definition.
    #
    # @param name [String] name of the attribute definition
    # @param description [String] description of the attribute definition
    # @param allows_multiple [Boolean] whether the attribute allows multiple values
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_team_attribute_definition(name, description, allows_multiple, headers=default_headers)
      body = {
        "allowsMultiple" => allows_multiple,
        "description" => description,
        "name" => name
      }
      @logger.info("Adding Team attribute definition \"#{name}\" to the \"#{space_slug}\" space.")
      # Create the team attribute definition
      post("#{@api_url}/teamAttributeDefinitions", body, headers)
    end

    # Delete a team attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_team_attribute_definition(name, headers=default_headers)
      @logger.info("Deleting the \"#{name}\" Team Attribute Definition")
      delete("#{@api_url}/teamAttributeDefinitions/#{encode(name)}", headers)
    end

    # Find a team attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_team_attribute_definition(name, params={}, headers=default_headers)
      @logger.info("Finding the \"#{name}\" Team Attribute Definition")
      get("#{@api_url}/teamAttributeDefinitions/#{encode(name)}", params, headers)
    end

    # Find all team attribute definitions
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_team_attribute_definitions(params={}, headers=default_headers)
      @logger.info("Finding Team Attribute Definitions")
      get("#{@api_url}/teamAttributeDefinitions", params, headers)
    end

    # Update a team attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param body [Hash] properties of the attribute definition to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_team_attribute_definition(name, body, headers=default_headers)
      @logger.info("Updating the \"#{name}\" Team Attribute Definition.")
      put("#{@api_url}/teamAttributeDefinitions/#{encode(name)}",body, headers)
    end

    # Add a new user attribute definition.
    #
    # @param name [String] name of the attribute definition
    # @param description [String] description of the attribute definition
    # @param allows_multiple [Boolean] whether the attribute allows multiple values
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_user_attribute_definition(name, description, allows_multiple, headers=default_headers)
      body = {
        "allowsMultiple" => allows_multiple,
        "description" => description,
        "name" => name
      }
      @logger.info("Adding User attribute definition \"#{name}\" to the \"#{space_slug}\" space.")
      # Create the user attribute definition
      post("#{@api_url}/userAttributeDefinitions", body, headers)
    end

    # Delete a user attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_user_attribute_definition(name, headers=default_headers)
      @logger.info("Deleting the \"#{name}\" User Attribute Definition")
      delete("#{@api_url}/userAttributeDefinitions/#{encode(name)}", headers)
    end

    # Find a user attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_user_attribute_definition(name, params={}, headers=default_headers)
      @logger.info("Finding the \"#{name}\" User Attribute Definition")
      get("#{@api_url}/userAttributeDefinitions/#{encode(name)}", params, headers)
    end

    # Find all user attribute definitions
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_user_attribute_definitions(params={}, headers=default_headers)
      @logger.info("Finding User Attribute Definitions")
      get("#{@api_url}/userAttributeDefinitions", params, headers)
    end

    # Update a user attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param body [Hash] properties of the attribute definition to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_user_attribute_definition(name, body, headers=default_headers)
      @logger.info("Updating the \"#{name}\" User Attribute Definition.")
      put("#{@api_url}/userAttributeDefinitions/#{encode(name)}",body, headers)
    end

    # Add a new user profile attribute definition.
    #
    # @param name [String] name of the attribute definition
    # @param description [String] description of the attribute definition
    # @param allows_multiple [Boolean] whether the attribute allows multiple values
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_user_profile_attribute_definition(name, description, allows_multiple, headers=default_headers)
      body = {
        "allowsMultiple" => allows_multiple,
        "description" => description,
        "name" => name
      }
      @logger.info("Adding User attribute definition \"#{name}\" to the \"#{space_slug}\" space.")
      # Create the user attribute definition
      post("#{@api_url}/userProfileAttributeDefinitions", body, headers)
    end

    # Delete a user profile attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_user_profile_attribute_definition(name, headers=default_headers)
      @logger.info("Deleting the \"#{name}\" User Profile Attribute Definition")
      delete("#{@api_url}/userProfileAttributeDefinitions/#{encode(name)}", headers)
    end

    # Find a user profile attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_user_profile_attribute_definition(name, params={}, headers=default_headers)
      @logger.info("Finding the \"#{name}\" User Profile Attribute Definition")
      get("#{@api_url}/userProfileAttributeDefinitions/#{encode(name)}", params, headers)
    end

    # Find user profile attribute definitions
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_user_profile_attribute_definitions(params={}, headers=default_headers)
      @logger.info("Finding User Profile Attribute Definitions")
      get("#{@api_url}/userProfileAttributeDefinitions", params, headers)
    end

    # Update a user profile attribute definition
    #
    # @param name [String] name of the attribute definition
    # @param body [Hash] properties of the attribute definition to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_user_profile_attribute_definition(name, body, headers=default_headers)
      @logger.info("Updating the \"#{name}\" User Profile Attribute Definition.")
      put("#{@api_url}/userProfileAttributeDefinitions/#{encode(name)}",body, headers)
    end

    # Add a new category attribute definition.
    #
    # @param kapp_slug [String] slug of the kapp where the category exists
    # @param name [String] name of the attribute definition
    # @param description [String] description of the attribute definition
    # @param allows_multiple [Boolean] whether the attribute allows multiple values
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_category_attribute_definition(kapp_slug, name, description, allows_multiple, headers=default_headers)
      body = {
        "allowsMultiple" => allows_multiple,
        "description" => description,
        "name" => name
      }
      @logger.info("Adding Category attribute definition \"#{name}\" to the \"#{kapp_slug}\" kapp.")
      # Create the attribute definition
      post("#{@api_url}/kapps/#{kapp_slug}/categoryAttributeDefinitions", body, headers)
    end

    # Delete a category attribute definition
    #
    # @param kapp_slug [String] slug of the kapp where the category exists
    # @param name [String] name of the attribute definition
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_category_attribute_definition(kapp_slug, name, headers=default_headers)
      @logger.info("Deleting the \"#{name}\" Category attribute definition from the \"#{kapp_slug}\" kapp.")
      delete("#{@api_url}/kapps/#{kapp_slug}/categoryAttributeDefinitions/#{encode(name)}", headers)
    end

    # Find a category attribute definition
    #
    # @param kapp_slug [String] slug of the kapp where the category exists
    # @param name [String] name of the attribute definition
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_category_attribute_definition(kapp_slug, name, params={}, headers=default_headers)
      @logger.info("Finding the \"#{name}\" Category attribute definition in the \"#{kapp_slug}\" kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}/categoryAttributeDefinitions/#{encode(name)}", params, headers)
    end

    # Find all category attribute definition
    #
    # @param kapp_slug [String] slug of the kapp where the categories exist
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_category_attribute_definitions(kapp_slug, params={}, headers=default_headers)
      @logger.info("Finding Category attribute definitions in the \"#{kapp_slug}\" kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}/categoryAttributeDefinitions", params, headers)
    end

    # Update a category attribute definition
    #
    # @param kapp_slug [String] slug of the kapp where the category exists
    # @param name [String] name of the attribute definition
    # @param body [Hash] properties of the attribute definition to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_category_attribute_definition(kapp_slug, name, body, headers=default_headers)
      @logger.info("Updating the \"#{name}\" Category attribute definition in the \"#{kapp_slug}\" kapp.")
      put("#{@api_url}/kapps/#{kapp_slug}/categoryAttributeDefinitions/#{encode(name)}",body, headers)
    end

    # Add a new form attribute definition.
    #
    # @param kapp_slug [String] slug of the kapp where the form exists
    # @param name [String] name of the attribute definition
    # @param description [String] description of the attribute definition
    # @param allows_multiple [Boolean] whether the attribute allows multiple values
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_form_attribute_definition(kapp_slug, name, description, allows_multiple, headers=default_headers)
      body = {
        "allowsMultiple" => allows_multiple,
        "description" => description,
        "name" => name
      }
      @logger.info("Adding Form attribute definition \"#{name}\" to the \"#{kapp_slug}\" kapp.")
      # Create the attribute definition
      post("#{@api_url}/kapps/#{kapp_slug}/formAttributeDefinitions", body, headers)
    end

    # Delete a form attribute definition
    #
    # @param kapp_slug [String] slug of the kapp where the form exists
    # @param name [String] name of the attribute definition
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_form_attribute_definition(kapp_slug, name, headers=default_headers)
      @logger.info("Deleting the \"#{name}\" Form attribute definition from the \"#{kapp_slug}\" kapp.")
      delete("#{@api_url}/kapps/#{kapp_slug}/formAttributeDefinitions/#{encode(name)}", headers)
    end

    # Find a form attribute definition
    #
    # @param kapp_slug [String] slug of the kapp where the form exists
    # @param name [String] name of the attribute definition
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_form_attribute_definition(kapp_slug, name, params={}, headers=default_headers)
      @logger.info("Finding the \"#{name}\" Form attribute definition in the \"#{kapp_slug}\" kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}/formAttributeDefinitions/#{encode(name)}", params, headers)
    end

    # Find all form attribute definition
    #
    # @param kapp_slug [String] slug of the kapp where the forms exist
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_form_attribute_definitions(kapp_slug, params={}, headers=default_headers)
      @logger.info("Finding Form attribute definitions in the \"#{kapp_slug}\" kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}/formAttributeDefinitions", params, headers)
    end

    # Update a form attribute definition
    #
    # @param kapp_slug [String] slug of the kapp where the form exists
    # @param name [String] name of the attribute definition
    # @param body [Hash] properties of the attribute definition to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_form_attribute_definition(kapp_slug, name, body, headers=default_headers)
      @logger.info("Updating the \"#{name}\" Form attribute definition in the \"#{kapp_slug}\" kapp.")
      put("#{@api_url}/kapps/#{kapp_slug}/formAttributeDefinitions/#{encode(name)}",body, headers)
    end

    # Add a new kapp attribute definition.
    #
    # @param kapp_slug [String] slug of the kapp
    # @param name [String] name of the attribute definition
    # @param description [String] description of the attribute definition
    # @param allows_multiple [Boolean] whether the attribute allows multiple values
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_kapp_attribute_definition(kapp_slug, name, description, allows_multiple, headers=default_headers)
      body = {
        "allowsMultiple" => allows_multiple,
        "description" => description,
        "name" => name
      }
      @logger.info("Adding Kapp attribute definition \"#{name}\" to the \"#{kapp_slug}\" kapp.")
      # Create the attribute definition
      post("#{@api_url}/kapps/#{kapp_slug}/kappAttributeDefinitions", body, headers)
    end

    # Delete a kapp attribute definition
    #
    # @param kapp_slug [String] slug of the kapp
    # @param name [String] name of the attribute definition
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_kapp_attribute_definition(kapp_slug, name, headers=default_headers)
      @logger.info("Deleting the \"#{name}\" Kapp attribute definition from the \"#{kapp_slug}\" kapp.")
      delete("#{@api_url}/kapps/#{kapp_slug}/kappAttributeDefinitions/#{encode(name)}", headers)
    end

    # Find a kapp attribute definition
    #
    # @param kapp_slug [String] slug of the kapp
    # @param name [String] name of the attribute definition
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_kapp_attribute_definition(kapp_slug, name, params={}, headers=default_headers)
      @logger.info("Finding the \"#{name}\" Kapp attribute definition in the \"#{kapp_slug}\" kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}/kappAttributeDefinitions/#{encode(name)}", params, headers)
    end

    # Find all kapp attribute definition
    #
    # @param kapp_slug [String] slug of the kapp
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_kapp_attribute_definitions(kapp_slug, params={}, headers=default_headers)
      @logger.info("Finding Kapp attribute definitions in the \"#{kapp_slug}\" kapp.")
      get("#{@api_url}/kapps/#{kapp_slug}/kappAttributeDefinitions", params, headers)
    end

    # Update a kapp attribute definition
    #
    # @param kapp_slug [String] slug of the kapp
    # @param name [String] name of the attribute definition
    # @param body [Hash] properties of the attribute definition to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_kapp_attribute_definition(kapp_slug, name, body, headers=default_headers)
      @logger.info("Updating the \"#{name}\" Kapp attribute definition in the \"#{kapp_slug}\" kapp.")
      put("#{@api_url}/kapps/#{kapp_slug}/kappAttributeDefinitions/#{encode(name)}",body, headers)
    end

  end
end
