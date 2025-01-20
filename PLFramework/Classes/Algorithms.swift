//
//  Algorithms.swift
//  PLFramework
//
//  Created by Can Kalender on 20.01.2025.
//

import Foundation

/// If we add new algorithms, we can create a new class that conforms to the PathFindingAlgorithm protocol.
public protocol PathFindingAlgorithm {
    func findClosestNode(from startNodeId: String,
                         withPointType pointType: String,
                         in graph: Graph)
                         throws -> (node: GraphNode, distance: Double)?
}

public class DijkstraAlgorithm: PathFindingAlgorithm {
        
    public init() {}
    
    public func findClosestNode(from startNodeId: String,
                                withPointType pointType: String,
                                in graph: Graph)
                                 throws -> (node: GraphNode, distance: Double)? {
        guard let startNode = graph.node(withId: startNodeId) else {
            throw PLErrors.startNodeNotFound(startNodeId)
        }
        
        var visited: [String: Double] = [startNodeId: 0]
        var queue: [(node: GraphNode, distance: Double)] = [(startNode, 0)]
        
        while !queue.isEmpty {
            let current = queue.removeFirst()
            
            if current.node.pointType == pointType {
                return current
            }
            
            if let edges = graph.edges(from: current.node.id) {
                for edge in edges {
                    let totalDistance = current.distance + edge.weight
                    
                    if let existingDistance = visited[edge.destinationId], existingDistance <= totalDistance {
                        continue
                    }
                    
                    visited[edge.destinationId] = totalDistance
                    if let nextNode = graph.node(withId: edge.destinationId) {
                        queue.append((nextNode, totalDistance))
                    }
                }
            }
            
            queue.sort { $0.distance < $1.distance }
        }
        
        throw PLErrors.noNodeWithPointType(pointType)
    }
}

public class BellmanFordAlgorithm: PathFindingAlgorithm {
    
    public init() {}
    
    public func findClosestNode(from startNodeId: String, withPointType pointType: String, in graph: Graph) throws -> (node: GraphNode, distance: Double)? {
        
        var distances: [String: Double] = [startNodeId: 0]
        var predecessors: [String: String] = [:]
        
        // Initialize distances to infinity
        for node in graph.nodes {
            if node.id != startNodeId {
                distances[node.id] = Double.infinity
            }
        }
        
        // Relax edges repeatedly
        for _ in 0..<graph.nodes.count - 1 {
            for node in graph.nodes {
                if let edges = graph.edges(from: node.id) {
                    for edge in edges {
                        if let currentDistance = distances[node.id], currentDistance + edge.weight < (distances[edge.destinationId] ?? Double.infinity) {
                            distances[edge.destinationId] = currentDistance + edge.weight
                            predecessors[edge.destinationId] = node.id
                        }
                    }
                }
            }
        }
        
        // Check for negative-weight cycles
        for node in graph.nodes {
            if let edges = graph.edges(from: node.id) {
                for edge in edges {
                    if let currentDistance = distances[node.id], currentDistance + edge.weight < (distances[edge.destinationId] ?? Double.infinity) {
                        throw PLErrors.negativeWeightCycleDetected
                    }
                }
            }
        }
        
        // Find the closest node with the specified point type
        var closestNode: GraphNode? = nil
        var minDistance = Double.infinity
        for (nodeId, distance) in distances {
            if let node = graph.node(withId: nodeId), node.pointType == pointType, distance < minDistance {
                closestNode = node
                minDistance = distance
            }
        }
        
        if let closestNode = closestNode {
            return (closestNode, minDistance)
        } else {
            throw PLErrors.noNodeWithPointType(pointType)
        }
    }
}
