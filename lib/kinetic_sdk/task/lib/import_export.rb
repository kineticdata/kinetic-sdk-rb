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

    # Import all structure definitions from
    # `export_directory/sources`.
    #
    # Imports the following items:
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
    # @param force_overwrite [Boolean] whether to overwrite handlers, trees and routines if they exist, default is false
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return nil
    def import(force_overwrite=false, headers=header_basic_auth)
      import_access_keys(headers)
      import_groups(headers)
      import_handlers(force_overwrite, headers)
      import_policy_rules(headers)
      import_routines(force_overwrite, headers)
      import_categories(headers)
      import_sources(headers)
      import_trees(force_overwrite, headers)
    end

  end
end
