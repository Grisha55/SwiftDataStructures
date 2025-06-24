// Node for doubly linked list
class DoublyNode<T> {
    var value: T
    var next: DoublyNode?
    weak var prev: DoublyNode?

    init(value: T) {
        self.value = value
    }
}

// Doubly linked list implementation
class DoublyLinkedList<T> {
    private var head: DoublyNode<T>?
    private var tail: DoublyNode<T>?

    // Add new element to the end of the list
    func append(_ value: T) {
        let newNode = DoublyNode(value: value)
        if let last = tail {
            last.next = newNode
            newNode.prev = last
            tail = newNode
        } else {
            head = newNode
            tail = newNode
        }
    }

    // Print list from head to tail
    func printForward() {
        var current = head
        while let node = current {
            print(node.value, terminator: " <-> ")
            current = node.next
        }
        print("nil")
    }

    // Print list from tail to head
    func printBackward() {
        var current = tail
        while let node = current {
            print(node.value, terminator: " <-> ")
            current = node.prev
        }
        print("nil")
    }
}

