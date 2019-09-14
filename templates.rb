require 'pp'

class Templates
  class Template
    def initialize(source)
      @source = source
    end

    def render(params)
      # Naive implementation
      # A parser would be more robust here
      lines = @source.split("\n")
      nodes = lines.map { |line| build_node(line) }
      tree = build_tree(nodes)
      pp tree
    end

    def build_node(line)
      indentation, line = /^( *)(.*)$/.match(line).captures
      indent = indentation.length / 2
      case line[0, 2]
      when '| '
        TextNode.new(indent, line[2..-1])
      when '= '
        CodeNode.new(indent, line[2..-1])
      else
        TagNode.new(indent, line, [])
      end
    end

    def build_tree(nodes)
      root = nodes.shift
      depth_map = { 0 => root }

      nodes.each do |node|
        parent = depth_map.fetch(node.indent - 1)
        # Push node onto parent
        parent.children << node
        # Remember this node as the next parent
        depth_map[node.indent] = node
      end

      root
    end
  end

  class TextNode < Struct.new(:indent, :text)
  end

  class CodeNode < Struct.new(:indent, :code)
  end

  class TagNode < Struct.new(:indent, :tag_name, :children)
  end
end
