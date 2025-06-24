// Node for singly linked list
class SinglyNode<T> {
    var value: T
    var next: SinglyNode?

    init(value: T) {
        self.value = value
    }
}

// Singly linked list implementation
class SinglyLinkedList<T> {
    private var head: SinglyNode<T>?

    // Add new element to the end of the list
    func append(_ value: T) {
        let newNode = SinglyNode(value: value)
        if let lastNode = getLastNode() {
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }

    // Get the last node in the list
    private func getLastNode() -> SinglyNode<T>? {
        var current = head
        while current?.next != nil {
            current = current?.next
        }
        return current
    }

    // Print all elements in the list
    func printList() {
        var current = head
        while let node = current {
            print(node.value, terminator: " -> ")
            current = node.next
        }
        print("nil")
    }
}

