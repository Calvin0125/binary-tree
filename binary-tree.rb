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
        unless array.is_a? Array
            return nil
        end
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
        unless value.is_a? Integer
            return nil
        end
        if @root == nil
            @root = Node.new(value)
            return @root
        end
        current_node = @root
        while true
            if value > current_node.data && current_node.right_child != nil
                current_node = current_node.right_child
            elsif value < current_node.data && current_node.left_child != nil
                current_node = current_node.left_child
            elsif value == current_node.data
                return nil
            elsif value > current_node.data && current_node.right_child == nil
                current_node.right_child = Node.new(value)
                return current_node.right_child
            elsif value < current_node.data && current_node.left_child == nil
                current_node.left_child = Node.new(value)
                return current_node.left_child
            end
        end
    end

    def delete(value)
        unless value.is_a? Integer
            return nil
        end
        if @root == nil
            return nil
        end
        current_node = @root
        while current_node.data != value
            previous_node = current_node
            if value > current_node.data
                current_node = current_node.right_child
            elsif value < current_node.data
                current_node = current_node.left_child
            end
            if current_node == nil
                return nil
            end
        end
        if current_node.left_child == nil && current_node.right_child == nil
            if previous_node.left_child == current_node
                previous_node.left_child = nil
                return current_node
            elsif previous_node.right_child == current_node
                previous_node.right_child = nil
                return current_node
            end
        elsif current_node.left_child != nil && current_node.right_child != nil
            before_successor = current_node
            inorder_successor = current_node.right_child
            while inorder_successor.left_child != nil
                before_successor = inorder_successor
                inorder_successor = inorder_successor.left_child
            end
            current_node.data = inorder_successor.data
            if before_successor.right_child == inorder_successor
                before_successor.right_child = nil
                return current_node
            elsif before_successor.left_child == inorder_successor
                before_successor.left_child = nil
                return current_node
            end
        else
            if current_node.left_child != nil
                current_node.data = current_node.left_child.data
                current_node.left_child = nil
                return current_node
            elsif current_node.right_child != nil
                current_node.data = current_node.right_child.data
                current_node.right_child = nil
                return current_node
            end
        end
    end
    
    def find(value)
        unless value.is_a? Integer
            return nil
        end
        if @root == nil
            return nil
        end
        current_node = @root
        while current_node.data != value
            if value > current_node.data
                current_node = current_node.right_child
            elsif value < current_node.data
                current_node = current_node.left_child
            end
            if current_node == nil
                return nil
            end
        end
        return current_node
    end

    def level_order(&block)
        if @root == nil
            return nil
        end
        queue = [@root]
        result = []
        while queue != []
            current_node = queue[0]
            if block_given?
                result << yield(current_node.data)
            else
                result << current_node.data
            end
            if current_node.left_child != nil
                queue << current_node.left_child
            end
            if current_node.right_child != nil
                queue << current_node.right_child
            end
            queue.shift
        end
        return result
    end


    def preorder(root = @root, result = [], &block)
        if root == nil
            return nil
        end
        if block_given?
            result << yield(root.data)
        else
            result << root.data
        end
        preorder(root.left_child, result, &block)
        preorder(root.right_child, result, &block)
        return result
    end

    def inorder(root = @root, result = [], &block)
        if root == nil
            return nil
        end
        inorder(root.left_child, result, &block)
        if block_given?
            result << yield(root.data)
        else
            result << root.data
        end
        inorder(root.right_child, result, &block)
        return result
    end

    def postorder(root = @root, result = [], &block)
        if root == nil
            return nil
        end
        postorder(root.left_child, result, &block)
        postorder(root.right_child, result, &block)
        if block_given?
            result << yield(root.data)
        else
            result << root.data
        end
        return result
    end

    def depth(root = @root)
        if root == nil
            return 0
        end
        right_depth = 1 + depth(root.right_child)
        left_depth = 1 + depth(root.left_child)
        return right_depth > left_depth ? right_depth : left_depth
    end

    def balanced?(root = @root)
        if root == nil
            return 0
        end
        right_depth = self.depth(self.root.right_child)
        left_depth = self.depth(self.root.left_child)
        if -1 <= (right_depth - left_depth) && (right_depth - left_depth) <= 1
            return true
        else
            return false
        end
    end

    def rebalance!
        array = self.level_order
        @root = build_tree(array)
    end

end

my_tree = Tree.new(Array.new(15) {rand(1..100)})
p my_tree
p my_tree.balanced?
p my_tree.level_order
p my_tree.preorder
p my_tree.inorder
p my_tree.postorder
my_tree.insert(105)
my_tree.insert(110)
my_tree.insert(115)
my_tree.insert(120)
my_tree.insert(125)
p my_tree.inorder
p my_tree.balanced?
my_tree.rebalance!
p my_tree.balanced?
p my_tree.level_order
p my_tree.preorder
p my_tree.inorder
p my_tree.postorder