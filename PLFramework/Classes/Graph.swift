//
//  Graph.swift
//  PLFramework
//
//  Created by Can Kalender on 19.01.2025.
//

import Foundation

public protocol GraphParserProtocol {
    static func parseGraph(from jsonData: Data) throws -> [String: GraphNode]
}

/// Class responsible for parsing graph data from JSON.
public class GraphParser: GraphParserProtocol {
    /// Parses a graph from JSON data.
    /// - Parameter jsonData: The JSON data representing the graph.
    /// - Returns: A dictionary representing the graph with node IDs as keys.
    /// - Throws: An error if the JSON data cannot be decoded.
    public static func parseGraph(from jsonData: Data) throws -> [String: GraphNode] {
        let decoder = JSONDecoder()
        do {
            // Decode the JSON array directly
            let rawNodes = try decoder.decode([GraphNode].self, from: jsonData)
            
            // Convert nodes to a dictionary by their IDs
            var graph: [String: GraphNode] = [:]
            for rawNode in rawNodes {
                let edges = rawNode.edges.map { GraphEdge(destinationId: $0.destinationId, weight: $0.weight) }
                let node = GraphNode(id: rawNode.id, pointType: rawNode.pointType, edges: edges)
                graph[rawNode.id] = node
            }
            
            return graph
        } catch let error as DecodingError {
            throw PLErrors.decodingError(error.localizedDescription)
        } catch {
            throw PLErrors.unknownError(error.localizedDescription)
        }
    }
}


/// A concrete implementation of the Graph protocol that uses a dictionary for efficient node storage and retrieval.
/// This class provides O(1) access time for node and edge lookups using a hash map structure where node IDs are keys.
///
/// Example usage:
/// ```
/// let graphData: [String: GraphNode] = ["A": nodeA, "B": nodeB]
/// let graph = DictionaryGraph(graph: graphData)
/// let nodeA = graph.node(withId: "A")
/// let edgesFromA = graph.edges(from: "A")
/// ```
public class DictionaryGraph: Graph {
    private let graph: [String: GraphNode]
    
    public init(graph: [String: GraphNode]) {
        self.graph = graph
    }
    
    public func node(withId id: String) -> GraphNode? {
        return graph[id]
    }
    
    public func edges(from nodeId: String) -> [GraphEdge]? {
        return graph[nodeId]?.edges
    }
    
    public var nodes: [GraphNode] {
        return Array(graph.values)
    }
}


/// A protocol that defines the basic operations for working with a graph data structure.
/// Any type conforming to this protocol must provide methods for accessing nodes and edges,
/// as well as a way to retrieve all nodes in the graph.
///
/// Graph implementations using this protocol can choose their own internal storage method
/// while maintaining a consistent interface for graph operations.
///
/// - Note: All methods may return nil if the requested node or edges don't exist.
public protocol Graph {
    /// Returns a specific node from the graph based on its ID.
    /// - Parameter id: The unique identifier of the node.
    /// - Returns: The node if found, nil otherwise.
    func node(withId id: String) -> GraphNode?
    
    /// Returns all edges originating from a specific node.
    /// - Parameter nodeId: The ID of the source node.
    /// - Returns: An array of edges if the node exists, nil otherwise.
    func edges(from nodeId: String) -> [GraphEdge]?
    
    /// All nodes currently in the graph.
    var nodes: [GraphNode] { get }
}
