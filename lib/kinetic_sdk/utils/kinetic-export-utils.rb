module KineticSdk
  module Utils

    # The KineticExportUtils module provides methods to simplify exporting
    # objects and writing to the local file system.
    module KineticExportUtils

      # Builds the tree structure of the export including the arguments
      #
      # @param args [Array] list of property names to include in the export:
      #   (i.e. slug, name, etc)
      # @return [Hash] struture of the shape to be exported
      def prepare_shape(*args)
        shape = {}
        args.each do |arg|
          segments = arg.split('.')
          pointer = shape
          segments.each do |segment|
            if segment =~ /\{(.*)\}/
              pointer[:variable] ||= $1
              pointer[$1] ||= {}
              pointer = pointer[$1]
            else
              pointer[segment] ||= {}
              pointer = pointer[segment]
            end
          end
        end
        shape
      end

      # Determines if the current path should be extracted further
      #
      # @param export_path [String] the path in which to determine if further extraction should occur
      # @param export_shape [Hash] the directory and file structure of how the data should be written
      # @return [Boolean] true if the path should be extracted further, otherwise false
      def should_extract(export_path, export_shape)
        # Prepare the metadata
        export_path_segments = export_path.split('.')
        pointer = export_shape
        result = true
        # Walk the export path
        export_path_segments.each do |export_path_segment|
          # If the object path corresponds to a "variable"
          if pointer.has_key?(:variable)
            pointer = pointer[pointer[:variable]]
          # If the object path corresponds to a static property
          else
            pointer = pointer[export_path_segment]
          end
          # If the pointer is null (indicating that the property should not be extracted)
          if pointer.nil?
            # Break out of the loop
            result = false
            break
          end
        end
        # Return the result
        result
      end

      # Fetches the variable property of a given path (ie slug, name, etc)
      #
      # @param export_shape [Hash] the directory and file structure of how the data should be written
      # @param object_path [String] the path in which to get the variable property from
      # @return [String] the value of the variable property, or nil if it doesn't exist
      def get_variable_property(export_shape, object_path)
        # Prepare the metadata
        object_path_segments = object_path.split('.')
        pointer = export_shape
        # Walk the object path
        object_path_segments.each do |object_path_segment|
          # If the object path corresponds to a "variable"
          if pointer.has_key?(:variable)
            pointer = pointer[pointer[:variable]]
          # If the object path corresponds to a static property
          else
            pointer = pointer[object_path_segment]
          end
          # If the pointer is null (indicating that the property should not be extracted)
          break if pointer.nil?
        end
        # Return the result
        pointer.nil? ? nil : pointer[:variable]
      end

      # Creates directory structure and writes file
      #
      # @param filename [String] the full path and name of the file to be written
      # @param file_contents [String] the content of the file to be written
      # @return nil
      def write_object_to_file(filename, file_contents)
        # Create Folder if not exists
        dir_path = File.dirname(filename)
        FileUtils.mkdir_p(dir_path, :mode => 0700)
        # Write File
        File.open(filename, 'w') { |file| file.write(JSON.pretty_generate(file_contents)) }
      end

      # Processes and writes data exported from the core service
      #
      # @param core_path [String] the root folder path to write the data to
      # @param export_shape [Hash] the directory and file structure of how the data should be written
      # @param object [Hash] the object being processed
      # @param object_path [String] the path of the object being processed (used recursively)
      # @return nil
      def process_export(core_path, export_shape, object, object_path='')
        # Prepare metadata
        child_objects = {}
        file_contents = {}
        if object.kind_of?(Array)
          file_contents = object
        else
          # For each of the object properties
          object.each do |key, value|
            # Build child object path
            child_object_path = object_path.empty? ? key : "#{object_path}.#{key}"

            # If the property should be extracted into its own folder/file
            if should_extract(child_object_path, export_shape)
              if value.kind_of?(Array)
                variable = get_variable_property(export_shape, child_object_path)
                if variable.nil?
                  child_objects[child_object_path] = value
                else
                  value.each do |item|
                    child_objects["#{child_object_path}.#{item[variable]}"] = item
                  end
                end
              else
                child_objects[child_object_path] = value
              end
            # If the property does not need to be extracted
            else
              # Add the property to the file contents
              file_contents[key] = value
            end
          end
        end

        # If this is not the "root" object
        if object_path != '' && !file_contents.empty?
          # Remove all `/` and `\` characters with ``
          # Replace all `.` with `/`
          # Replace all `::` with `-` (this ensures nested Teams/Categories maintain a separator)
          # Replace all non-slug characters with ``
          filename = "#{core_path}/#{object_path.gsub('/\\', '').gsub('.', '/').gsub(/::/, '-').gsub(/[^a-zA-Z0-9_\-\/]/, '')}.json"
          # Write the file_contents based upon the
          write_object_to_file(filename, file_contents)
        end

        # For each of the child objects
        child_objects.each do |key, child_object|
          # Process the export for that object (recursively)
          process_export(core_path, export_shape, child_object, key)
        end
      end

    end
  end
end
