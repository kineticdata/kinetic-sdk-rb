module KineticSdk
  class Task

    # Export all structure definitions to :source-slug.json file in
    # `export_directory/sources`.
    #
    # Exports the following items:
    #
    # * sources
    # * trees
    # * routines
    # * handlers
    # * groups
    # * policy rules
    # * categories
    # * access keys
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return nil
    def export(headers=header_basic_auth)
      export_sources(headers)
      export_trees(nil,headers)
      export_routines(headers)
      export_handlers(headers)
      export_groups(headers)
      export_policy_rules(headers)
      export_categories(headers)
      export_access_keys(headers)
    end
    

  end
end
