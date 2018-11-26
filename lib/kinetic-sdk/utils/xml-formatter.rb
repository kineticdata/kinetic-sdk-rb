require 'rexml/document'

class ComparisonFormat < REXML::Formatters::Pretty

    def write_element(elm, out)
        att = elm.attributes

        class <<att
            alias _each_attribute each_attribute

            def each_attribute(&b)
                to_enum(:_each_attribute).sort_by {|x| x.name}.each(&b)
            end
        end

        super(elm, out)
    end

    def write_text( node, output )
        s = node.to_s()
        #s.gsub!(/\s/,' ')
        #s.squeeze!(" ")

        #The Pretty formatter code mistakenly used 80 instead of the @width variable
        #s = wrap(s, 80-@level)
        #s = wrap(s, @width-@level)

        s = indent_text(s, @level, " ", true)
        output << (' '*@level + s)
    end

end