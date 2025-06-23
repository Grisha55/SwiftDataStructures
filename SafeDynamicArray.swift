struct SafeDynamicArray<T> {
    private var storage: [T?] // Internal storage using optional values
    private(set) var count: Int = 0 // Number of actual elements

    // Initial capacity of the array
    init(initialCapacity: Int = 2) {
        precondition(initialCapacity > 0, "Initial capacity must be greater than 0")
        storage = Array(repeating: nil, count: initialCapacity)
    }

    // Computed property for current capacity
    var capacity: Int {
        return storage.count
    }

    // Access elements with bounds checking
    subscript(index: Int) -> T {
        get {
            precondition(index >= 0 && index < count, "Index out of bounds")
            return storage[index]!
        }
        set {
            precondition(index >= 0 && index < count, "Index out of bounds")
            storage[index] = newValue
        }
    }

    /// Appends an element to the end of the array
    mutating func append(_ value: T) {
        if count == capacity {
            resize()
        }
        storage[count] = value
        count += 1
    }

    /// Inserts an element at a specific index and shifts the others to the right
    mutating func insert(_ value: T, at index: Int) {
        precondition(index >= 0 && index <= count, "Index out of bounds")

        if count == capacity {
            resize()
        }

        // Shift elements to the right
        for i in stride(from: count, to: index, by: -1) {
            storage[i] = storage[i - 1]
        }

        storage[index] = value
        count += 1
    }

    /// Removes the element at a specific index and shifts the others to the left
    mutating func remove(at index: Int) -> T {
        precondition(index >= 0 && index < count, "Index out of bounds")

        let removed = storage[index]!

        // Shift elements to the left
        for i in index..<count - 1 {
            storage[i] = storage[i + 1]
        }

        storage[count - 1] = nil
        count -= 1
        return removed
    }

    /// Doubles the capacity of the storage array
    private mutating func resize() {
        let newCapacity = max(1, capacity * 2)
        storage += Array(repeating: nil, count: newCapacity - capacity)
    }

    /// Prints all elements in the array
    func printElements() {
        for i in 0..<count {
            if let value = storage[i] {
                print(value, terminator: " ")
            }
        }
        print()
    }
}

