module KineticSdk
  class Task

    # Export all structure definitions to `export_directory`.
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
    # @param export_opts [Hash] hash of export options
    #   - :include_workflows => true|false (default: false)
    # @return nil
    def export(headers=header_basic_auth, export_opts={})
      export_sources(headers)
      export_trees(nil,headers,export_opts) # Includes routines when nil passed
      export_handlers(headers)
      export_groups(headers)
      export_policy_rules(headers)
      export_categories(headers)
      export_access_keys(headers)
    end


    # Export all structure definitions except trees and routines to `export_directory`.
    #
    # Exports the following items:
    #
    # * sources
    # * handlers
    # * groups
    # * policy rules
    # * categories
    # * access keys
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication
    # @return nil
    def export_all_except_trees(headers=header_basic_auth)
      export_sources(headers)
      export_handlers(headers)
      export_groups(headers)
      export_policy_rules(headers)
      export_categories(headers)
      export_access_keys(headers)
    end
  end
end
