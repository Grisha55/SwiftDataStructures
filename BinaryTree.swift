// Binary tree node
class TreeNode<T: Comparable> {
    var value: T
    var left: TreeNode?
    var right: TreeNode?

    init(_ value: T) {
        self.value = value
    }
}

// Binary Search Tree (BST) with insert, search, delete, and visualization
class BinaryTree<T: Comparable> {
    var root: TreeNode<T>?

    // MARK: - Insert node
    func insert(_ value: T) {
        root = insert(from: root, value)
    }

    private func insert(from node: TreeNode<T>?, _ value: T) -> TreeNode<T> {
        guard let node = node else {
            return TreeNode(value)
        }

        if value < node.value {
            node.left = insert(from: node.left, value)
        } else {
            node.right = insert(from: node.right, value)
        }
        return node
    }

    // MARK: - Search (Contains)
    func contains(_ value: T) -> Bool {
        return contains(from: root, value)
    }

    private func contains(from node: TreeNode<T>?, _ value: T) -> Bool {
        guard let node = node else { return false }

        if value == node.value {
            return true
        } else if value < node.value {
            return contains(from: node.left, value)
        } else {
            return contains(from: node.right, value)
        }
    }

    // MARK: - Remove node
    func remove(_ value: T) {
        root = remove(from: root, value)
    }

    private func remove(from node: TreeNode<T>?, _ value: T) -> TreeNode<T>? {
        guard let node = node else { return nil }

        if value < node.value {
            node.left = remove(from: node.left, value)
        } else if value > node.value {
            node.right = remove(from: node.right, value)
        } else {
            // Node found
            if node.left == nil && node.right == nil {
                return nil // No children
            } else if node.left == nil {
                return node.right // One right child
            } else if node.right == nil {
                return node.left // One left child
            } else {
                // Two children
                if let minRight = findMin(node.right) {
                    node.value = minRight.value
                    node.right = remove(from: node.right, minRight.value)
                }
            }
        }

        return node
    }

    private func findMin(_ node: TreeNode<T>?) -> TreeNode<T>? {
        var current = node
        while current?.left != nil {
            current = current?.left
        }
        return current
    }

    // MARK: - Inorder traversal (Left -> Root -> Right)
    func inorder() {
        print("Inorder traversal:")
        inorder(root)
        print()
    }

    private func inorder(_ node: TreeNode<T>?) {
        guard let node = node else { return }
        inorder(node.left)
        print(node.value, terminator: " ")
        inorder(node.right)
    }

    // MARK: - Tree visualization (console print)
    func printTree() {
        print("Tree structure:")
        printTree(node: root, prefix: "", isLeft: true)
    }

    private func printTree(node: TreeNode<T>?, prefix: String, isLeft: Bool) {
        guard let node = node else { return }
        print(prefix + (isLeft ? "├── " : "└── ") + "\(node.value)")
        if node.left != nil || node.right != nil {
            printTree(node: node.left, prefix: prefix + (isLeft ? "│   " : "    "), isLeft: true)
            printTree(node: node.right, prefix: prefix + (isLeft ? "│   " : "    "), isLeft: false)
        }
    }
}

