struct Queue<T> {
    // Internal storage using two arrays for performance optimization
    private var enqueueStack: [T] = []  // Stack for enqueue operations
    private var dequeueStack: [T] = []  // Stack for dequeue operations

    // Add an element to the back of the queue
    mutating func enqueue(_ value: T) {
        enqueueStack.append(value)
    }

    // Remove and return the element at the front of the queue
    mutating func dequeue() -> T? {
        if dequeueStack.isEmpty {
            // Transfer elements from enqueueStack to dequeueStack in reverse order
            dequeueStack = enqueueStack.reversed()
            enqueueStack.removeAll()
        }
        return dequeueStack.popLast()
    }

    // Peek at the front element without removing it
    func peek() -> T? {
        return dequeueStack.last ?? enqueueStack.first
    }

    // Check if the queue is empty
    var isEmpty: Bool {
        return enqueueStack.isEmpty && dequeueStack.isEmpty
    }

    // Return the number of elements in the queue
    var count: Int {
        return enqueueStack.count + dequeueStack.count
    }
}

