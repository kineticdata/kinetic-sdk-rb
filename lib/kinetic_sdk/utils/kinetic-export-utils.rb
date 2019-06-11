module KineticSdk
  module Utils
    module KineticExportUtils

      # Builds the tree structure of the export including variables (ie slug, name, etc)
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
      # Params:
      # +export_path+:: the path in which to determine if further extraction should occur
      # +export_shape: the directory and file structure of how the data should be written
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
      # Params:
      # +export_shape: the directory and file structure of how the data should be written
      # +object_path+:: the path in which to get the variable property from
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
      # Params:
      # +filename: the full path and name of the file to be written
      # +file_contents+:: the content of the file to be written
      def write_object_to_file(filename, file_contents)
        # Create Folder if not exists
        dir_path = File.dirname(filename)
        FileUtils.mkdir_p(dir_path, :mode => 0700)
        # Write File
        File.open(filename, 'w') { |file| file.write(JSON.pretty_generate(file_contents)) }
      end

      # Processes and writes data exported from the core service
      # Params:
      # +core_path: the root folder path to write the data to
      # +export_shape+:: the directory and file structure of how the data should be written
      # +object+:: the object being processed
      # +object_path+:: the path of the object being processed (used recursively)
      def process_export(core_path, export_shape, object, object_path='')
        # Prepare metadata
        child_objects = {}
        file_contents = {}
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

        # If this is not the "root" object
        if object_path != ''
          # Write the file_contents based upon the
          filename = "#{core_path}/#{object_path.gsub('.', '/')}.json"
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
