import Foundation

/// A generic Heap (priority queue) data structure.
/// Can be used as Min-Heap or Max-Heap depending on the comparator passed.
public struct Heap<Element> {
    /// The array that stores heap elements
    private var elements: [Element]
    
    /// The priority function determines whether this is a min-heap or max-heap.
    /// For min-heap use: (a, b) -> a < b
    /// For max-heap use: (a, b) -> a > b
    private let priorityFunction: (Element, Element) -> Bool

    /// Initializes a new heap.
    /// - Parameters:
    ///   - elements: optional array to heapify
    ///   - priorityFunction: closure defining heap type (min or max)
    public init(elements: [Element] = [], priorityFunction: @escaping (Element, Element) -> Bool) {
        self.elements = elements
        self.priorityFunction = priorityFunction
        buildHeap()
    }

    /// Returns true if heap is empty
    public var isEmpty: Bool {
        return elements.isEmpty
    }

    /// Number of elements in the heap
    public var count: Int {
        return elements.count
    }

    /// Returns the root element (highest/lowest priority depending on heap type)
    public func peek() -> Element? {
        return elements.first
    }

    /// Checks whether a given element exists in the heap using custom equality
    public func contains(_ element: Element, where equals: (Element, Element) -> Bool) -> Bool {
        return elements.contains { equals($0, element) }
    }

    /// Inserts a new element into the heap and maintains heap property
    public mutating func insert(_ value: Element) {
        elements.append(value)
        siftUp(from: elements.count - 1)
    }

    /// Removes and returns the root element (highest/lowest priority)
    public mutating func remove() -> Element? {
        guard !isEmpty else { return nil }

        if elements.count == 1 {
            return elements.removeFirst()
        } else {
            let root = elements[0]
            elements[0] = elements.removeLast()
            siftDown(from: 0)
            return root
        }
    }

    /// Removes and returns element at specific index (useful for arbitrary deletions)
    public mutating func remove(at index: Int) -> Element? {
        guard index < elements.count else { return nil }

        let lastIndex = elements.count - 1
        if index != lastIndex {
            elements.swapAt(index, lastIndex)
            let removed = elements.removeLast()
            // Restore heap property both directions
            siftDown(from: index)
            siftUp(from: index)
            return removed
        } else {
            return elements.removeLast()
        }
    }

    /// Replaces the element at a specific index and re-heapifies
    public mutating func replace(at index: Int, with value: Element) {
        guard index < elements.count else { return }
        let oldValue = elements[index]
        elements[index] = value

        // Decide whether to sift up or down depending on priority
        if priorityFunction(value, oldValue) {
            siftUp(from: index)
        } else {
            siftDown(from: index)
        }
    }

    /// Returns a sorted array without modifying the original heap
    public func heapSorted() -> [Element] {
        var copy = self
        var result: [Element] = []
        while let top = copy.remove() {
            result.append(top)
        }
        return result
    }

    /// Builds a valid heap from an unsorted array
    private mutating func buildHeap() {
        // Start from the last parent node and sift down
        for index in stride(from: (elements.count / 2 - 1), through: 0, by: -1) {
            siftDown(from: index)
        }
    }

    /// Moves the element at index up the tree until heap property is restored
    private mutating func siftUp(from index: Int) {
        var childIndex = index
        let child = elements[childIndex]
        var parentIndex = self.parentIndex(of: childIndex)

        // While child is higher priority than parent, move it up
        while childIndex > 0 && priorityFunction(child, elements[parentIndex]) {
            elements[childIndex] = elements[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(of: childIndex)
        }

        elements[childIndex] = child
    }

    /// Moves the element at index down the tree until heap property is restored
    private mutating func siftDown(from index: Int) {
        var parentIndex = index

        while true {
            let left = leftChildIndex(of: parentIndex)
            let right = rightChildIndex(of: parentIndex)
            var candidate = parentIndex

            // Compare left and right children to find higher priority
            if left < elements.count && priorityFunction(elements[left], elements[candidate]) {
                candidate = left
            }

            if right < elements.count && priorityFunction(elements[right], elements[candidate]) {
                candidate = right
            }

            // If parent is already in correct place, stop
            if candidate == parentIndex {
                return
            }

            // Swap and continue
            elements.swapAt(parentIndex, candidate)
            parentIndex = candidate
        }
    }

    /// Returns the index of the parent for the given index
    private func parentIndex(of index: Int) -> Int {
        return (index - 1) / 2
    }

    /// Returns the index of the left child for the given index
    private func leftChildIndex(of index: Int) -> Int {
        return 2 * index + 1
    }

    /// Returns the index of the right child for the given index
    private func rightChildIndex(of index: Int) -> Int {
        return 2 * index + 2
    }
}


// ---------------------------------------------------------------------------------
//🧪 main() - Usage Examples:

func main() {
    print("=== Min-Heap ===")
    var minHeap = Heap<Int>(priorityFunction: <)
    minHeap.insert(10)
    minHeap.insert(4)
    minHeap.insert(15)
    minHeap.insert(1)

    print("Root:", minHeap.peek() ?? "nil")        // 1
    print("Removed root:", minHeap.remove() ?? 0)   // 1
    print("After remove:", minHeap.peek() ?? "nil") // 4

    minHeap.replace(at: 1, with: 2)
    print("After replace at index 1:", minHeap.heapSorted())

    print("Contains 10:", minHeap.contains(10, where: ==)) // true

    print("\n=== Max-Heap ===")
    var maxHeap = Heap(elements: [3, 1, 6, 7], priorityFunction: >)
    maxHeap.insert(9)
    print("Root:", maxHeap.peek() ?? "nil")         // 9
    print("Sorted:", maxHeap.heapSorted())          // descending order

    print("\n=== Custom Struct ===")
    struct Task: Equatable {
        let name: String
        let priority: Int
    }

    var taskHeap = Heap<Task>(
        priorityFunction: { $0.priority < $1.priority } // Min-heap by priority
    )

    taskHeap.insert(Task(name: "Clean", priority: 3))
    taskHeap.insert(Task(name: "Code", priority: 1))
    taskHeap.insert(Task(name: "Sleep", priority: 5))

    print("Top task:", taskHeap.peek()?.name ?? "none") // Code
    print("All tasks:", taskHeap.heapSorted().map { $0.name }) // Sorted by priority
}

main()

