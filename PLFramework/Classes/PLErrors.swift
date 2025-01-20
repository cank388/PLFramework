//
//  PLErrors.swift
//  PLFramework
//
//  Created by Can Kalender on 20.01.2025.
//

import Foundation

/// Errors that can be thrown by the PLFramework.
public enum PLErrors: Error, LocalizedError {
    case startNodeNotFound(String)
    case noNodeWithPointType(String)
    case negativeWeightCycleDetected
    case graphParsingError(String)
    case unknownError(String)
    case decodingError(String)

    public var errorDescription: String? {
        switch self {
        case .startNodeNotFound(let nodeId):
            return "Error: Start node with ID \(nodeId) not found."
        case .noNodeWithPointType(let pointType):
            return "Error: No node with point type \(pointType) found."
        case .negativeWeightCycleDetected:
            return "Error: Negative-weight cycle detected."
        case .graphParsingError(let message):
            return "Graph parsing error: \(message)"
        case .unknownError(let message):
            return "Unexpected error: \(message)"
        case .decodingError(let message):
            return "Decoding Error: \(message)"
        }
    }
}
