//
//  PathFinding.swift
//  PLFramework
//
//  Created by Can Kalender on 19.01.2025.
//

import Foundation

/// PLNavigator is the main class responsible for pathfinding operations on a graph structure.
/// It handles operations such as finding nearest points and calculating routes on the graph.
public class PLNavigator {
    private let graph: Graph
    private let configuration: PLNavigatorConfiguration
    
    public init(graph: Graph,
                configuration: PLNavigatorConfiguration = PLNavigatorConfiguration()) {
        self.graph = graph
        self.configuration = configuration
    }
    
    /// Static method to find the closest node of a specified type from a given starting point on the graph
    /// - Parameters:
    ///   - jsonData: JSON data containing the graph structure
    ///   - startNodeId: Unique identifier of the starting node
    ///   - pointType: Type of point to search for
    ///   - algorithm: Pathfinding algorithm to use (default: Dijkstra)
    /// - Returns: A tuple containing the closest node and its distance
    /// - Throws: PLErrors or other errors during the process
    public static func findClosestNode(from jsonData: Data,
                                       startNodeId: String,
                                       pointType: String,
                                       algorithm: PathFindingAlgorithm = DijkstraAlgorithm())
                                        throws -> (node: GraphNode,
                                                   distance: Double)? {
                                            
        do {
            let graphDictionary = try GraphParser.parseGraph(from: jsonData)
            let graph = DictionaryGraph(graph: graphDictionary)
            let configuration = PLNavigatorConfiguration(pathFindingAlgorithm: algorithm)
            let navigator = PLNavigator(graph: graph, configuration: configuration)
            
            return try navigator.findClosestNode(from: startNodeId, withPointType: pointType)
        } catch let error as PLErrors {
            throw error
        } catch {
            throw error
        }
    }
}

extension PLNavigator {
    /// Instance method to find the closest node of a specified type from a given starting point
    /// - Parameters:
    ///   - startNodeId: Unique identifier of the starting node
    ///   - pointType: Type of point to search for
    /// - Returns: A tuple containing the closest node and its distance
    /// - Throws: PLErrors.startNodeNotFound if the starting node doesn't exist
    public func findClosestNode(from startNodeId: String,
                                withPointType pointType: String)
                                throws -> (node: GraphNode,
                                           distance: Double)? {
        guard graph.node(withId: startNodeId) != nil else {
            throw PLErrors.startNodeNotFound(startNodeId)
        }
        
        return try configuration.pathFindingAlgorithm.findClosestNode(from: startNodeId, withPointType: pointType, in: graph)
    }
}

/// Configuration class for PLNavigator
/// Contains basic settings such as the pathfinding algorithm
public struct PLNavigatorConfiguration {
    /// The pathfinding algorithm to be used
    let pathFindingAlgorithm: PathFindingAlgorithm
    
    /// Initializer with default configuration
    /// - Parameter pathFindingAlgorithm: The pathfinding algorithm to use (default: Dijkstra)
    public init(pathFindingAlgorithm: PathFindingAlgorithm = DijkstraAlgorithm()) {
        self.pathFindingAlgorithm = pathFindingAlgorithm
    }
}

