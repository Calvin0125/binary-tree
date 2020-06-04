class Node
    attr_accessor :data, :left_child, :right_child
    def initialize(data)
        @data = data
        @left_child = nil
        @right_child = nil
    end
end

class Tree
    attr_reader :root
    def initialize(array)
        @root = build_tree(array)
    end
    
    def build_tree(array)
        if array == []
            return nil
        elsif array.length == 1
            return Node.new(array[0])
        end
        array.uniq!
        array.sort!
        root = Node.new(array.delete_at(array.length/2))
        left = array.slice(0, ((array.length.to_f/2.0).round))
        right = array.slice((left.length), (array.length-left.length))
        root.left_child = build_tree(left)
        root.right_child = build_tree(right)
        return root
    end
    def insert(value)
        if
end

my_tree = Tree.new([1,2,3,4,5,6])

p my_tree.root.left_child.data


