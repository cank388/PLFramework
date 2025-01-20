//
//  Models.swift
//  PLFramework
//
//  Created by Can Kalender on 19.01.2025.
//

import Foundation

public struct GraphNode: Decodable {
    public let id: String
    public let pointType: String
    public var edges: [GraphEdge]
    
    enum CodingKeys: String, CodingKey {
        case id
        case pointType
        case edges
    }

    public init(id: String, pointType: String, edges: [GraphEdge]) {
        self.id = id
        self.pointType = pointType
        self.edges = edges
    }
}

public struct GraphEdge: Decodable {
    public let destinationId: String
    public let weight: Double

    enum CodingKeys: String, CodingKey {
        case destinationId = "id"
        case weight
    }
    
    public init(destinationId: String, weight: Double) {
        self.destinationId = destinationId
        self.weight = weight
    }
}
