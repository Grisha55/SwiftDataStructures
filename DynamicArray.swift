final class DynamicArray<T> {
    private var capacity: Int           // Current allocated capacity
    private var count: Int              // Number of actual elements stored
    private var storage: UnsafeMutablePointer<T?> // Pointer to the underlying storage

    init(initialCapacity: Int = 2) {
        self.capacity = initialCapacity
        self.count = 0
        self.storage = UnsafeMutablePointer<T?>.allocate(capacity: capacity)
        self.storage.initialize(repeating: nil, count: capacity)
    }

    deinit {
        // Clean up memory when the array is deallocated
        storage.deinitialize(count: capacity)
        storage.deallocate()
    }

    var size: Int {
        return count
    }

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

    /// Appends a new element to the end of the array
    func append(_ value: T) {
        if count == capacity {
            resize() // Double the capacity if needed
        }
        storage[count] = value
        count += 1
    }

    /// Inserts an element at a specific index and shifts subsequent elements
    func insert(_ value: T, at index: Int) {
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

    /// Removes the element at the specified index and shifts elements left
    func remove(at index: Int) -> T {
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

    /// Doubles the array capacity and copies existing elements
    private func resize() {
        let newCapacity = capacity * 2
        let newStorage = UnsafeMutablePointer<T?>.allocate(capacity: newCapacity)
        newStorage.initialize(repeating: nil, count: newCapacity)

        // Copy old elements to new storage
        for i in 0..<count {
            newStorage[i] = storage[i]
        }

        // Deallocate old memory and update pointers
        storage.deinitialize(count: capacity)
        storage.deallocate()
        storage = newStorage
        capacity = newCapacity
    }

    /// Prints all elements of the array
    func printElements() {
        for i in 0..<count {
            if let value = storage[i] {
                print(value, terminator: " ")
            }
        }
        print()
    }
}

