require 'rexml/document'

class Prettier < REXML::Formatters::Default

  def initialize( indentation = 4 )
    @indentation = indentation
    @level = 0
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
      output << "></#{node.expanded_name}>"
    else
      element_nodes = node.children.select { |child| child.kind_of?(REXML::Element) }.size
      processed_element_nodes = 0

      output << ">"
      @level += @indentation
      node.children.each_index { |index|
        child = node.children[index]
        next if child.kind_of?(REXML::Text) && node.expanded_name != "parameter" && child.to_s.strip.length == 0
        if child.kind_of?(REXML::Element) then
          processed_element_nodes += 1
          write_indent_level(output, true)
        end
        write( child, output )
      }
      @level -= @indentation if @level >= @indentation
      write_indent_level(output, true) if element_nodes > 0 && processed_element_nodes == element_nodes
      output << "</#{node.expanded_name}>"
    end
  end

  private
  def write_indent_level(output, newline = false)
    output << "\n" if newline
    output << ' ' * @level
  end

end