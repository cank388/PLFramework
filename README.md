# PLFramework

PLFramework is a Swift library that provides pathfinding capabilities on graph structures. It includes implementations of popular pathfinding algorithms like Dijkstra and Bellman-Ford.

[![CI Status](https://img.shields.io/travis/cank388/PLFramework.svg?style=flat)](https://travis-ci.org/cank388/PLFramework)
[![Version](https://img.shields.io/cocoapods/v/PLFramework.svg?style=flat)](https://cocoapods.org/pods/PLFramework)
[![License](https://img.shields.io/cocoapods/l/PLFramework.svg?style=flat)](https://cocoapods.org/pods/PLFramework)
[![Platform](https://img.shields.io/cocoapods/p/PLFramework.svg?style=flat)](https://cocoapods.org/pods/PLFramework)

## Features

- Graph structure representation
- Multiple pathfinding algorithms (Dijkstra, Bellman-Ford)
- JSON-based graph data parsing
- Flexible configuration options
- Type-safe error handling

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

PLFramework is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PLFramework'
```

## Usage

### Creating a Graph from JSON
```

let jsonData = """
[
  {
    "id": "A",
    "pointType": "entrance",
    "edges": [
      {"id": "B", "weight": 5.0},
      {"id": "C", "weight": 3.0}
    ]
  },
  {
    "id": "B",
    "pointType": "exit",
    "edges": [
      {"id": "A", "weight": 5.0}
    ]
  }
]
""".data(using: .utf8)!
let graph = try GraphParser.parseGraph(from: jsonData)
```

### Finding the Closest Node
```
// Using static method
let result = try PLNavigator.findClosestNode(from: jsonData,
                                             startNodeId: "A",
                                             pointType: "exit")
// Using instance method
let navigator = PLNavigator(graph: DictionaryGraph(graph: graph))
let closestNode = try navigator.findClosestNode(from: "A",
                                                withPointType: "exit")
```

### Using Different Algorithms
```

// Using Bellman-Ford algorithm
let config = PLNavigatorConfiguration(pathFindingAlgorithm: BellmanFordAlgorithm())
let navigator = PLNavigator(graph: graph, configuration: config)

```

## Error Handling

The framework provides comprehensive error handling through `PLErrors`:

- `startNodeNotFound`: When the specified start node doesn't exist
- `noNodeWithPointType`: When no node of the specified type is found
- `negativeWeightCycleDetected`: When using Bellman-Ford and a negative cycle is found
- `graphParsingError`: When JSON parsing fails
- `decodingError`: When JSON decoding fails
- `unknownError`: For unexpected errors

## Requirements

- iOS 10.0+
- Swift 5.0+
- XCode 15.2

## Screenshots of Example App

<img src="https://github.com/user-attachments/assets/de2e238f-719e-4123-a978-4034b3107b2b" width="300" alt="Simulator Screenshot 1">
<img src="https://github.com/user-attachments/assets/80db9c76-98db-44ee-81e9-b0267fd9ac67" width="300" alt="Simulator Screenshot 2">

## Nasıl Yaptım? 

Öncelikle modelleri oluşturdum. GraphNode ve GraphEdge olarak isimlendirdim. Sonrasında bu graph.json verisini parse edecek yapıyı kurdum.
Daha sonra djikstra algoritmasını claude yardımıyla kurdum. Example app içinde json verisini parse edip framework'u çağırıp hesaplamaları yaptırdım.
Sonrasında ise olabildiğince genişletebilir bir yapı kurmaya çalıştım. Error kontrolleri ekledim. 

Özetle önce basit yapıyı kurgulayıp, çalıştığını görüp, sonrasında genişlettim.

## Author

cank388, cankalender.tr@gmail.com

## License

PLFramework is available under the MIT license. See the LICENSE file for more info.
