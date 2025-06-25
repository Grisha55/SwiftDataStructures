import Foundation

struct HashNode<Key: Hashable, Value> {
    let key: Key
    var value: Value
}

class HashTable<Key: Hashable, Value> {
    
    private var buckets: [[HashNode<Key, Value>]]
    private(set) var count = 0
    private var capacity: Int
    private let loadFactor: Double = 0.75 // Max load factor before resizing
    
    init(capacity: Int = 16) {
        self.capacity = capacity
        self.buckets = Array(repeating: [], count: capacity)
    }
    
    private func index(forKey key: Key) -> Int {
        return abs(key.hashValue) % capacity
    }
    
    /// Inserts or updates a value for the given key
    func insert(key: Key, value: Value) {
        let index = index(forKey: key)
        
        for (i, node) in buckets[index].enumerated() {
            if node.key == key {
                buckets[index][i].value = value
                return
            }
        }
        
        let newNode = HashNode(key: key, value: value)
        buckets[index].append(newNode)
        count += 1
        
        // Resize the table if load factor exceeded
        if Double(count) / Double(capacity) > loadFactor {
            resize()
        }
    }
    
    /// Retrieves value for the given key
    func get(key: Key) -> Value? {
        let index = index(forKey: key)
        
        for node in buckets[index] {
            if node.key == key {
                return node.value
            }
        }
        return nil
    }
    
    /// Removes a key-value pair from the table
    func remove(key: Key) -> Value? {
        let index = index(forKey: key)
        
        for (i, node) in buckets[index].enumerated() {
            if node.key == key {
                buckets[index].remove(at: i)
                count -= 1
                return node.value
            }
        }
        return nil
    }
    
    /// Returns true if key exists in the table
    func contains(key: Key) -> Bool {
        return get(key: key) != nil
    }
    
    /// Prints contents of the hash table (for debug)
    func printTable() {
        for (i, bucket) in buckets.enumerated() {
            print("Bucket \(i):")
            for node in bucket {
                print("  [\(node.key): \(node.value)]")
            }
        }
    }
    
    /// Dynamically resizes the table and rehashes all entries
    private func resize() {
        let oldBuckets = buckets
        capacity *= 2
        buckets = Array(repeating: [], count: capacity)
        count = 0 // Will be updated in insert
        
        for bucket in oldBuckets {
            for node in bucket {
                insert(key: node.key, value: node.value)
            }
        }
    }
    
    // MARK: - Subscript Support
    
    /// Allows convenient access via table[key] syntax
    subscript(key: Key) -> Value? {
        get {
            return get(key: key)
        }
        set {
            if let value = newValue {
                insert(key: key, value: value)
            } else {
                _ = remove(key: key)
            }
        }
    }
}


// --------------------------------------------------

//Example of use with subscript and auto-extension:

let table = HashTable<String, Int>()

// Using subscript to insert
table["one"] = 1
table["two"] = 2
table["three"] = 3

// Update existing key
table["one"] = 100

// Access
print(table["one"] ?? "Not found") // Output: 100

// Remove
table["two"] = nil
print(table["two"] ?? "Not found") // Output: Not found

// Force resize by inserting many elements
for i in 0..<100 {
    table["key\(i)"] = i
}

table.printTable()
