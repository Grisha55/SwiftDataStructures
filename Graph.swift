import Foundation

/// A weighted graph structure that supports:
/// - Adding/removing vertices and edges (directed or undirected)
/// - Finding shortest paths using Dijkstra's algorithm
class WeightedGraph<T: Hashable> {
    
    /// The adjacency list stores each vertex and its connected neighbors with edge weights.
    private var adjacencyList: [T: [(vertex: T, weight: Double)]] = [:]
    
    // MARK: - Vertex Operations
    
    /// Adds a vertex to the graph. If it already exists, does nothing.
    func addVertex(_ vertex: T) {
        if adjacencyList[vertex] == nil {
            adjacencyList[vertex] = []
        }
    }
    
    /// Removes a vertex and all associated edges.
    func removeVertex(_ vertex: T) {
        // Remove all edges pointing to this vertex
        for (key, neighbors) in adjacencyList {
            adjacencyList[key] = neighbors.filter { $0.vertex != vertex }
        }
        // Remove the vertex itself
        adjacencyList.removeValue(forKey: vertex)
    }
    
    // MARK: - Edge Operations
    
    /// Adds a directed edge from `source` to `destination` with a given weight.
    /// Set `bidirectional` to true to add an undirected edge.
    func addEdge(from source: T, to destination: T, weight: Double, bidirectional: Bool = false) {
        addVertex(source)
        addVertex(destination)
        adjacencyList[source]?.append((vertex: destination, weight: weight))
        
        if bidirectional {
            adjacencyList[destination]?.append((vertex: source, weight: weight))
        }
    }
    
    /// Removes an edge from `source` to `destination`.
    /// If `bidirectional` is true, removes both directions.
    func removeEdge(from source: T, to destination: T, bidirectional: Bool = false) {
        if var edges = adjacencyList[source] {
            edges.removeAll { $0.vertex == destination }
            adjacencyList[source] = edges
        }
        
        if bidirectional {
            if var reverseEdges = adjacencyList[destination] {
                reverseEdges.removeAll { $0.vertex == source }
                adjacencyList[destination] = reverseEdges
            }
        }
    }
    
    // MARK: - Dijkstra's Algorithm
    
    /// Dijkstra's algorithm to find the shortest path from a starting vertex
    /// to all other vertices in the graph.
    func dijkstra(from source: T) -> [T: Double] {
        var distances: [T: Double] = [:]
        for vertex in adjacencyList.keys {
            distances[vertex] = Double.infinity
        }
        distances[source] = 0
        
        var priorityQueue: [(vertex: T, distance: Double)] = [(source, 0)]
        
        while !priorityQueue.isEmpty {
            // Sort queue by distance (inefficient, but simple)
            priorityQueue.sort { $0.distance < $1.distance }
            let (currentVertex, currentDistance) = priorityQueue.removeFirst()
            
            if currentDistance > distances[currentVertex]! {
                continue
            }
            
            for (neighbor, weight) in adjacencyList[currentVertex] ?? [] {
                let distanceThroughCurrent = currentDistance + weight
                if distanceThroughCurrent < distances[neighbor]! {
                    distances[neighbor] = distanceThroughCurrent
                    priorityQueue.append((neighbor, distanceThroughCurrent))
                }
            }
        }
        
        return distances
    }
    
    // MARK: - Print
    
    /// Prints the adjacency list of the graph.
    func printGraph() {
        print("Weighted Graph adjacency list:")
        for (vertex, neighbors) in adjacencyList {
            let edges = neighbors.map { "\($0.vertex)(\($0.weight))" }.joined(separator: ", ")
            print("\(vertex): [\(edges)]")
        }
    }
}


// ---------------------------------------------------------

// Example of use with subscript and auto-extension:
let graph = WeightedGraph<String>()

graph.addEdge(from: "A", to: "B", weight: 5)
graph.addEdge(from: "A", to: "C", weight: 2)
graph.addEdge(from: "C", to: "D", weight: 1)
graph.addEdge(from: "D", to: "E", weight: 3)
graph.addEdge(from: "B", to: "E", weight: 10)
graph.addEdge(from: "E", to: "F", weight: 2)

graph.printGraph()

print("\nУдаляем ребро B → E:")
graph.removeEdge(from: "B", to: "E")
graph.printGraph()

print("\nУдаляем вершину D:")
graph.removeVertex("D")
graph.printGraph()

let shortest = graph.dijkstra(from: "A")
print("\nКратчайшие расстояния от A:")
for (vertex, distance) in shortest {
    print("A → \(vertex): \(distance)")
}

