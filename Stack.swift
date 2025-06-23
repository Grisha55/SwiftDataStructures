struct Stack<T> {
    // Internal storage for the stack
    private var elements: [T] = []

    // Push an element onto the stack (add to top)
    mutating func push(_ value: T) {
        elements.append(value)
    }

    // Pop the top element off the stack (remove from top)
    mutating func pop() -> T? {
        return elements.popLast()
    }

    // Peek at the top element without removing it
    func peek() -> T? {
        return elements.last
    }

    // Check if the stack is empty
    var isEmpty: Bool {
        return elements.isEmpty
    }

    // Return the number of elements in the stack
    var count: Int {
        return elements.count
    }
}

