require 'rexml/document'

class ComparisonFormat < REXML::Formatters::Default

  def initialize( indentation=2, ie_hack=false )
    @indentation = indentation
    @level = 0
    @ie_hack = ie_hack
  end

  protected
  def write_element( node, output )
    output << "<#{node.expanded_name}"
    
    att = node.attributes
    class <<att
      def each_attribute_sorted(&b)
          to_enum(:each_attribute).sort_by {|x| x.name}.each(&b)
      end
    end

    node.attributes.each_attribute_sorted do |attr|
      output << " "
      attr.write( output )
    end unless node.attributes.empty?

    if node.children.empty?
      output << " " if @ie_hack
      output << "/"
    else
      output << ">"
      # If compact and all children are text, and if the formatted output
      # is less than the specified width, then try to print everything on
      # one line
      @level += @indentation
      first_child = true
      node.children.each_index { |index|
        child = node.children[index]
        # Need to preserve whitespace for edge cases where someone wants just whitespace for a parameter input
        next if child.kind_of?(REXML::Text) && node.expanded_name != "parameter" && child.to_s.strip.length == 0
        if child.kind_of?(REXML::Element) && first_child then
          first_child = false
          output << "\n"
          output << ' '*@level
        end
        write( child, output )
        #@level -= @indentation if (index + 1) == node.children.length && @level != 0
      }
      @level -= @indentation if @level != 0
      output << "</#{node.expanded_name}"
    end
    output << ">"
    output << "\n"
    output << ' '*@level
  end

end